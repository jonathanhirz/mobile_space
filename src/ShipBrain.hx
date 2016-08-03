import luxe.Component;
import luxe.Vector;
import luxe.Sprite;
import luxe.Input;
import luxe.Text;
import luxe.components.sprite.SpriteAnimation;

class ShipBrain extends Component {

    var ship : Sprite;
    public var ship_velocity : Vector = new Vector(0,0);
    var ship_velocity_max : Float = 10;
    var ship_acceleration : Vector = new Vector(0,0);
    var ship_speed : Float = 1.5;
    var ship_exhaust_anim : SpriteAnimation;
    var ship_exhaust_anim_2 : SpriteAnimation;

    var touches : Array<TouchEvent>;
    var movement_touch : TouchEvent;
    var movement_touch_initial_position : Vector = new Vector(0,0);
    var movement_touch_space : Float = 0.05;
    var fire_touch : TouchEvent;
    var left_side_touched : Bool = false;
    var right_side_touched : Bool = false;

    var movement_touch_icon : Sprite;

    public function new(_name:String) {
        super({ name:_name});
    } //new

    override function init() {

        ship = cast entity;
        touches = [];


        //todo: animate exhaust powering down by shrinking
        //todo: make the exhaust a single animation/sprite
        // exhaust 1 sprite
        var ship_exhaust = new Sprite({
            name : "ship_exhaust",
            texture : Luxe.resources.texture('assets/exhaust.png'),
            size : new Vector(16, 32),
            rotation_z : 180,
            pos : new Vector(16, 64),
            depth : 2
        });
        ship_exhaust.parent = ship;
        // exhaust 1 animation
        var exhaust_anim = Luxe.resources.json('assets/exhaust.json');
        ship_exhaust_anim = ship_exhaust.add(new SpriteAnimation({ name:'exhaust' }));
        ship_exhaust_anim.add_from_json_object(exhaust_anim.asset.json);
        ship_exhaust_anim.animation = 'idle';
        ship_exhaust_anim.play();

        // exhaust 2 sprite
        var ship_exhaust_2 = new Sprite({
            name : "ship_exhaust_2",
            texture : Luxe.resources.texture('assets/exhaust.png'),
            size : new Vector(16, 32),
            rotation_z : 180,
            pos : new Vector(48, 64),
            depth : 2
        });
        ship_exhaust_2.parent = ship;
        // exhaust 2 animation
        var exhaust_anim_2 = Luxe.resources.json('assets/exhaust.json');
        ship_exhaust_anim_2 = ship_exhaust_2.add(new SpriteAnimation({ name:'exhaust' }));
        ship_exhaust_anim_2.add_from_json_object(exhaust_anim.asset.json);
        ship_exhaust_anim_2.animation = 'idle';
        ship_exhaust_anim_2.play();

        // movement_touch_icon
        movement_touch_icon = new Sprite({
            name : 'movement_touch_icon',
            texture : Luxe.resources.texture('assets/movement_touch_icon.png'),
            size : new Vector(64, 64),
            depth : 1,
            visible : true

        }); //movement_touch_icon

    } //init

    override function update(dt:Float) {

        ship_velocity.add(ship_acceleration);
        ship_velocity.x = luxe.utils.Maths.clamp(ship_velocity.x, -ship_velocity_max, ship_velocity_max);
        ship_velocity.y = luxe.utils.Maths.clamp(ship_velocity.y, -ship_velocity_max, ship_velocity_max);
        pos.add(ship_velocity);
        // maybe...needs to be smoother
        // Luxe.camera.zoom = 1 - ((ship_velocity.length / 10) * 0.5);
        ship_velocity.multiply(new Vector(0.99, 0.99));
        // if(Math.abs(ship_velocity.x) < 0.0005) ship_velocity.x = 0;
        // if(Math.abs(ship_velocity.y) < 0.0005) ship_velocity.y = 0;
        if(ship_velocity.x != 0 || ship_velocity.y != 0) {
            ship.rotation_z = Math.atan2(ship_velocity.y, ship_velocity.x) * (180/Math.PI) + 90;
        }

        //====KEY CONTROLS====
        if(Luxe.input.inputdown('up')) {
            ship_acceleration.y = -ship_speed;
            start_exhaust();
        }
        if(Luxe.input.inputreleased('up')) {
            ship_acceleration.y = 0;
            stop_exhaust();
        }
        if(Luxe.input.inputdown('down')) {
            ship_acceleration.y = ship_speed;
            start_exhaust();
        }
        if(Luxe.input.inputreleased('down')) {
            ship_acceleration.y = 0;
            stop_exhaust();
        }
        if(Luxe.input.inputdown('left')) {
            ship_acceleration.x = -ship_speed;
            start_exhaust();
        }
        if(Luxe.input.inputreleased('left')) {
            ship_acceleration.x = 0;
            stop_exhaust();
        }
        if(Luxe.input.inputdown('right')) {
            ship_acceleration.x = ship_speed;
            start_exhaust();
        }
        if(Luxe.input.inputreleased('right')) {
            ship_acceleration.x = 0;
            stop_exhaust();
        }
        if(Luxe.input.inputpressed('space')) {
            ship_velocity = new Vector(0,0);
            stop_exhaust();
        }

        //====TOUCH CONTROLS====
        //todo: have the start touch point drag around with the finger if it gets too far away. this way it isn't hard to find center
        if(touches.length > 0) {
            for(touch in touches) {
                //do stuff
            }
        }
        if(movement_touch != null) {
            //todo: touch controls need tweaking. need to be able to move in cardinal directions easily
            var touch_y = movement_touch.pos.y - movement_touch_initial_position.y;
            var touch_x = movement_touch.pos.x - movement_touch_initial_position.x;
            var angle = Math.atan2(touch_y, touch_x);
            ship_acceleration.x = ship_speed * Math.cos(angle);
            ship_acceleration.y = ship_speed * Math.sin(angle);
            start_exhaust();
            if(!left_side_touched) {
                ship_acceleration.x = 0;
                ship_acceleration.y = 0;
                stop_exhaust();
            } //stop ship
        }

    } //update

    override function ontouchdown(e:TouchEvent) {

        touches.push(e);
        if(e.pos.x < 0.5 && !left_side_touched) {
            movement_touch = e;
            movement_touch_initial_position = movement_touch.pos.clone();
            left_side_touched = true;
        }
        if(e.pos.x > 0.5 && !right_side_touched) {
            fire_touch = e;
            right_side_touched = true;
        }

    } //ontouchdown

    override function ontouchup(e:TouchEvent) {

        for(touch in touches) {
            if(touch.touch_id == e.touch_id) {
                if(left_side_touched && touch.touch_id == movement_touch.touch_id) {
                    left_side_touched = false;
                }
                if(right_side_touched && touch.touch_id == fire_touch.touch_id) {
                    right_side_touched = false;
                }
                touches.remove(touch);
            }
        }

    } //ontouchup

    override function ontouchmove(e:TouchEvent) {

        for(touch in touches) {
            if(touch.touch_id == e.touch_id) {
                touch.pos.set_xy(e.pos.x, e.pos.y);
            }
        }

    } //ontouchmove

    function start_exhaust() {

        if(ship_exhaust_anim.animation != 'fire') {
            ship_exhaust_anim.animation = 'fire';
            ship_exhaust_anim_2.animation = 'fire';
        }

    } //start_exhaust

    function stop_exhaust() {

        ship_exhaust_anim.animation = 'idle';
        ship_exhaust_anim_2.animation = 'idle';

    } //stop_exhaust

} //ShipBrain

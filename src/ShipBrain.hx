import luxe.Component;
import luxe.Vector;
import luxe.Sprite;
import luxe.tween.Actuate;
import luxe.components.sprite.SpriteAnimation;

class ShipBrain extends Component {

    var ship : Sprite;
    public var ship_velocity : Vector = new Vector(0,0);
    var ship_velocity_max : Float = 10;
    var ship_acceleration : Vector = new Vector(0,0);
    var ship_speed : Float = 1.5;
    var ship_exhaust_anim : SpriteAnimation;
    var ship_exhaust_anim_2 : SpriteAnimation;

    public function new(_name:String) {
        super({ name:_name});
    } //new

    override function init() {

        ship = cast entity;

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
            if(ship_exhaust_anim.animation != 'fire') {
                ship_exhaust_anim.animation = 'fire';
                ship_exhaust_anim_2.animation = 'fire';
            }
        }
        if(Luxe.input.inputreleased('up')) {
            ship_acceleration.y = 0;
            ship_exhaust_anim.animation = 'idle';
            ship_exhaust_anim_2.animation = 'idle';
        }
        if(Luxe.input.inputdown('down')) {
            ship_acceleration.y = ship_speed;
            if(ship_exhaust_anim.animation != 'fire') {
                ship_exhaust_anim.animation = 'fire';
                ship_exhaust_anim_2.animation = 'fire';
            }        }
        if(Luxe.input.inputreleased('down')) {
            ship_acceleration.y = 0;
            ship_exhaust_anim.animation = 'idle';
            ship_exhaust_anim_2.animation = 'idle';
        }
        if(Luxe.input.inputdown('left')) {
            ship_acceleration.x = -ship_speed;
            if(ship_exhaust_anim.animation != 'fire') {
                ship_exhaust_anim.animation = 'fire';
                ship_exhaust_anim_2.animation = 'fire';
            }        }
        if(Luxe.input.inputreleased('left')) {
            ship_acceleration.x = 0;
            ship_exhaust_anim.animation = 'idle';
            ship_exhaust_anim_2.animation = 'idle';
        }
        if(Luxe.input.inputdown('right')) {
            ship_acceleration.x = ship_speed;
            if(ship_exhaust_anim.animation != 'fire') {
                ship_exhaust_anim.animation = 'fire';
                ship_exhaust_anim_2.animation = 'fire';
            }        }
        if(Luxe.input.inputreleased('right')) {
            ship_acceleration.x = 0;
            ship_exhaust_anim.animation = 'idle';
            ship_exhaust_anim_2.animation = 'idle';
        }
        if(Luxe.input.inputpressed('space')) {
            ship_velocity = new Vector(0,0);
            ship_exhaust_anim.animation = 'idle';
            ship_exhaust_anim_2.animation = 'idle';
        }

        //====TOUCH CONTROLS====
        //todo: touch controls

    } //update

} //ShipBrain
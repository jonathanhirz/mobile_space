import luxe.Component;
import luxe.Vector;
import luxe.Sprite;
import luxe.tween.Actuate;

class ShipBrain extends Component {

    var ship : Sprite;
    var ship_velocity : Vector = new Vector(0,0);
    var ship_acceleration : Vector = new Vector(0,0);
    var ship_speed : Float = 1;

    public function new(_name:String) {
        super({ name:_name});
    } //new

    override function init() {

        ship = cast entity;

    } //init

    override function update(dt:Float) {

        //todo: CLAMPS
        ship_velocity.add(ship_acceleration);
        pos.add(ship_velocity);
        ship_velocity.multiply(new Vector(0.85, 0.85));
        ship.rotation_z = Math.atan2(ship_velocity.y, ship_velocity.x) * (180/Math.PI) + 90;
        //todo: engine exhaust

        //====KEY CONTROLS====
        if(Luxe.input.inputdown('up')) {
            ship_acceleration.y = -ship_speed;
        }
        if(Luxe.input.inputreleased('up')) {
            ship_acceleration.y = 0;
        }
        if(Luxe.input.inputdown('down')) {
            ship_acceleration.y = ship_speed;
        }
        if(Luxe.input.inputreleased('down')) {
            ship_acceleration.y = 0;
        }
        if(Luxe.input.inputdown('left')) {
            ship_acceleration.x = -ship_speed;
        }
        if(Luxe.input.inputreleased('left')) {
            ship_acceleration.x = 0;
        }
        if(Luxe.input.inputdown('right')) {
            ship_acceleration.x = ship_speed;
        }
        if(Luxe.input.inputreleased('right')) {
            ship_acceleration.x = 0;
        }

        //====TOUCH CONTROLS====

    } //update

    function rotate_ship_to(_angle:Float) {
        //rotation.toeuler() gives the DEGREES of the rotation
        //rotation.setFromEuler() takes the RADIAN of the rotation
        Actuate.tween(ship, .1, {rotation_z : _angle} );


    } //rotate_ship_to

} //ShipBrain
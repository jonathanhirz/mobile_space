import luxe.Component;
import luxe.Vector;
import luxe.Color;
import luxe.Sprite;
import luxe.Particles;
import phoenix.Texture;

class ShipExhaust extends Component {

    var ship : Sprite;
    var particle : Texture;
    var exhaust : ParticleSystem;

    public function new(_name:String) {
        super({ name:_name });
    } //new

    override function init() {

        ship = cast entity;
        particle = Luxe.resources.texture('assets/particle.png');
        exhaust = new ParticleSystem({ name:'exhaust' });
        exhaust.pos = ship.pos;
        exhaust.add_emitter({
            name : 'exhaust',
            particle_image : particle,
            depth : 0,
            gravity : new Vector(0,0),
            speed : 5.0,
            pos_random : new Vector(0,0),
            start_size : new Vector(16,16),
            end_size : new Vector(1,1),
            start_size_random : new Vector(0,0),
            end_size_random : new Vector(2,2),
            start_color : new Color().rgb(0x7ba4ca),
            end_color : new Color().rgb(0x7ba4ca),
            emit_time : 0.01,
            life : 0.75
        });

    } //init

    override function update(dt:Float) {

        exhaust.get('exhaust').direction = ship.rotation_z + 270;
        trace(exhaust.get('exhaust').emit_count);

    } //update

} //ShipExhaust
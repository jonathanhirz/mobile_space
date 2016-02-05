package states;
import luxe.States;
import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

import luxe.Parcel;
import luxe.ParcelProgress;

class PlayState extends State {

    var player_ship : Sprite;

    public function new( _name:String ) {
        super({ name:_name });
    } //new

    override function init() {

        var parcel = new Parcel({
            textures : [
                { id: 'assets/blue_ship.png' },
                { id: 'assets/star.png' }
             ],
        });

        new ParcelProgress({
            parcel : parcel,
            background : new Color().rgb(0x2e2e2e),
            oncomplete : assets_loaded
        });

        parcel.load();

    } //init

    function assets_loaded(_) {

        create_player();
        create_stars();

    } //assets_loaded

    override function onenter<T>( _value:T ) {


    } //onenter

    override function onleave<T>( _value:T ) {


    } //onleave

    override function update(dt:Float) {


    } //update

    function create_player() {

        player_ship = new Sprite({
            name : 'player_ship',
            texture : Luxe.resources.texture('assets/blue_ship.png'),
            pos : Luxe.screen.mid
        });

    } //create_player

    function create_stars() {

        var stars : Array<Sprite> = [];
        for(i in 0...100) {
            var star = new Sprite({
            name : 'star',
            name_unique : true,
            texture : Luxe.resources.texture('assets/star.png'),
            pos : new Vector(Luxe.utils.random.int(0, Luxe.screen.w), Luxe.utils.random.int(0, Luxe.screen.h))
        });
        stars.push(star);
        }

    } //create_stars

} //PlayState
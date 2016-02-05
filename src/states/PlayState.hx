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

        create_stars();
        create_player();

    } //assets_loaded

    override function onenter<T>( _value:T ) {


    } //onenter

    override function onleave<T>( _value:T ) {


    } //onleave

    override function update(dt:Float) {

        if(player_ship != null) {
            Luxe.camera.center.weighted_average_xy(player_ship.pos.x, player_ship.pos.y, 10);
        }

    } //update

    function create_player() {

        player_ship = new Sprite({
            name : 'player_ship',
            texture : Luxe.resources.texture('assets/blue_ship.png'),
            pos : Luxe.screen.mid,
            depth : 0
        });
        player_ship.add(new ShipBrain('ship_brain'));

    } //create_player

    function create_stars() {

        var stars : Array<Sprite> = [];
        for(i in 0...100) {
            var star = new Sprite({
                name : 'star',
                name_unique : true,
                texture : Luxe.resources.texture('assets/star.png'),
                pos : new Vector(Luxe.utils.random.int(0, Luxe.screen.w), Luxe.utils.random.int(0, Luxe.screen.h)),
                depth : -1
            });
        stars.push(star);
        } //for loop
        //todo: more stars when camera moves
        //todo: cleanup far away stars

    } //create_stars

} //PlayState
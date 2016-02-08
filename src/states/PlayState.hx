package states;
import luxe.States;
import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

import luxe.Parcel;
import luxe.ParcelProgress;

class PlayState extends State {

    var player_ship : Sprite;
    var player_ship_component : ShipBrain;
    var stars : Array<Sprite> = [];
    var current_star : Int = 0;

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

        create_stars(100);
        place_stars_in_sector(50, 0, 0);
        place_stars_in_sector(50, 0, 1);
        place_stars_in_sector(50, 0, -1);
        place_stars_in_sector(50, 1, 0);
        place_stars_in_sector(50, 1, 1);
        place_stars_in_sector(50, 1, -1);
        place_stars_in_sector(50, -1, -1);
        place_stars_in_sector(50, -1, 0);
        place_stars_in_sector(50, -1, 1);
        create_player();
        player_ship_component = player_ship.get('ship_brain');

    } //assets_loaded

    override function onenter<T>( _value:T ) {


    } //onenter

    override function onleave<T>( _value:T ) {


    } //onleave

    override function update(dt:Float) {

        if(player_ship != null) {
            Luxe.camera.center.weighted_average_xy(player_ship.pos.x, player_ship.pos.y, 10);
            if(player_ship_component.ship_velocity.y < 0) {

            }
            if(player_ship_component.ship_velocity.y > 0) {

            }
            if(player_ship_component.ship_velocity.x < 0) {

            }
            if(player_ship_component.ship_velocity.x > 0) {

            }
            
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

    function create_stars(_number_of_stars:Int) {

        for(i in 0..._number_of_stars) {
            var star = new Sprite({
                name : 'star',
                name_unique : true,
                texture : Luxe.resources.texture('assets/star.png'),
                depth : -1
            });
        stars.push(star);
        } //for loop

    } //create_stars

    function place_stars_in_sector(_number_of_stars:Int, _sector_x:Int, _sector_y:Int) {

        Luxe.utils.random.initial = 42 + _sector_x + _sector_y;
        for(i in 0..._number_of_stars) {
            stars[current_star].pos = new Vector((_sector_x * Luxe.screen.w) + (Luxe.utils.random.get() * Luxe.screen.w), (_sector_y * Luxe.screen.h) + (Luxe.utils.random.get() * Luxe.screen.h));
            current_star++;
            if(current_star > stars.length - 1) current_star = 0;
        } //for loop

    } //place_stars_in_sector

    //todo: maybe work on generating a cloud of stars that follows the player around
    // and when a star moves off camera+some, just move it to the front/moving edge
    // ...either that, or the sector of stars idea (better, but much more complex)
    //todo: generate more stars as camera moves
    function create_more_stars() {


    } //create_more_stars

    //todo: cleanup far away stars
    function clean_up_stars() {


    } //clean_up_stars

} //PlayState
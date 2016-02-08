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
    var player_ship_sector : Vector = new Vector(0,0);
    var stars : Array<Sprite> = [];
    var current_star : Int = 0;
    var stars_per_sector : Int = 50;

    public function new( _name:String ) {
        super({ name:_name });
    } //new

    override function init() {

        // Luxe.camera.zoom = 0.2;

        var parcel = new Parcel({
            textures : [
                { id: 'assets/blue_ship.png' },
                { id: 'assets/star.png' }
             ],
        });

        new ParcelProgress({
            parcel : parcel,
            background : new Color().rgb(0x1a1a1a),
            oncomplete : assets_loaded
        });

        parcel.load();

    } //init

    function assets_loaded(_) {

        // generate pool of stars
        create_stars(1500);
        // place the initial 9 sectors of stars around player's initial position
        for(col in -1...2) {
            for(row in -1...2) {
                place_stars_in_sector(stars_per_sector, col, row);
            }
        }
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

            var _current_sector = new Vector(Math.floor(player_ship.pos.x / Luxe.screen.w), Math.floor(player_ship.pos.y / Luxe.screen.h));
            // trace(_current_sector, player_ship_sector);

            //todo: sometimes stars near the player get moved, resulting in empty sectors...
            if(_current_sector.y < player_ship_sector.y) {
                //draw stars up
                for(i in -1...2) {
                    place_stars_in_sector(stars_per_sector, _current_sector.x + i, _current_sector.y - 1);
                }
                player_ship_sector = _current_sector;
            }
            if(_current_sector.y > player_ship_sector.y) {
                //draw stars down
                for(i in -1...2) {
                    place_stars_in_sector(stars_per_sector, _current_sector.x + i, _current_sector.y + 1);
                }
                player_ship_sector = _current_sector;
            }
            if(_current_sector.x < player_ship_sector.x) {
                //draw stars left
                for(i in -1...2) {
                    place_stars_in_sector(stars_per_sector, _current_sector.x - 1, _current_sector.y + i);
                }
                player_ship_sector = _current_sector;
            }
            if(_current_sector.x > player_ship_sector.x) {
                //draw stars right
                for(i in -1...2) {
                    place_stars_in_sector(stars_per_sector, _current_sector.x + 1, _current_sector.y + i);
                }
                player_ship_sector = _current_sector;
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
                depth : -1,
                visible : false
            });
        stars.push(star);
        } //for loop

    } //create_stars

    function place_stars_in_sector(_number_of_stars:Int, _sector_x:Float, _sector_y:Float) {

        Luxe.utils.random.initial = 42 + _sector_x + _sector_y;
        for(i in 0..._number_of_stars) {
            stars[current_star].pos = new Vector((_sector_x * Luxe.screen.w) + (Luxe.utils.random.get() * Luxe.screen.w), (_sector_y * Luxe.screen.h) + (Luxe.utils.random.get() * Luxe.screen.h));
            stars[current_star].visible = true;
            current_star++;
            if(current_star > stars.length - 1) current_star = 0;
        } //for loop

    } //place_stars_in_sector

} //PlayState
package states;
import luxe.States;
import luxe.Color;
import luxe.Sprite;
import luxe.Vector;

import luxe.components.sprite.SpriteAnimation;

import luxe.Parcel;
import luxe.ParcelProgress;

import phoenix.Texture.ClampType;

class GameState extends State {

    var player_ship : Sprite;
    var player_ship_component : ShipBrain;
    var star_background : Sprite;
    var star_background_back : Sprite;

    public function new( _name:String ) {
        super({ name:_name });
    } //new

    override function init() {

        #if desktop
        Luxe.camera.zoom = 0.5;
        #end

        #if mobile
        Luxe.camera.zoom = 1;
        #end

        var parcel = new Parcel({
            textures : [
                { id : 'assets/blue_ship.png' },
                { id : 'assets/exhaust.png' },
                { id : 'assets/star_background.png' },
                { id : 'assets/star_background_back.png' },
                { id : 'assets/movement_touch_icon.png' }
             ],
             jsons : [
                { id : 'assets/exhaust.json'}
            ]
        });

        new ParcelProgress({
            parcel : parcel,
            background : new Color().rgb(0x1a1a1a),
            oncomplete : assets_loaded
        });

        parcel.load();

    } //init

    function assets_loaded(_) {

        create_background();
        //todo: split out entities/components in the new way
        create_player();
        player_ship_component = player_ship.get('ship_brain');
        

        var random_sprite = new Sprite({
            size : new Vector(64,64),
            color : new Color().rgb(0x2fca21),
            pos : new Vector(-100,120)
        });
        var random_sprite_2 = new Sprite({
            size : new Vector(64,64),
            color : new Color().rgb(0xca021e),
            pos : new Vector(80,-70)
        });
        var random_sprite_3 = new Sprite({
            size : new Vector(64,64),
            color : new Color().rgb(0x2138ca),
            pos : new Vector(150,170)
        });

    } //assets_loaded

    override function onenter<T>( _value:T ) {


    } //onenter

    override function onleave<T>( _value:T ) {


    } //onleave

    override function update(dt:Float) {

        if(player_ship != null) {
            Luxe.camera.center.weighted_average_xy(player_ship.pos.x, player_ship.pos.y, 1);
            update_background();
        }

    } //update

    function create_background() {

        star_background = new Sprite({
            name : 'star_background',
            texture : Luxe.resources.texture('assets/star_background.png'),
            pos : new Vector(0,0),
            depth : -1
        });
        star_background.texture.clamp_s = star_background.texture.clamp_t = ClampType.repeat;

        star_background_back = new Sprite({
            name : 'star_background_back',
            texture : Luxe.resources.texture('assets/star_background_back.png'),
            pos : new Vector(0,0),
            depth : -2
        });
        star_background_back.texture.clamp_s = star_background_back.texture.clamp_t = ClampType.repeat;

    } //create_background

    function update_background() {

        star_background.pos = player_ship.pos.clone();
        star_background_back.pos = player_ship.pos.clone();
        star_background.uv.x = player_ship.pos.x / 2;
        star_background.uv.y = player_ship.pos.y / 2;
        star_background_back.uv.x = player_ship.pos.x / 4;
        star_background_back.uv.y = player_ship.pos.y / 4;

    } //update_background

    function create_player() {

        // ship sprite
        player_ship = new Sprite({
            name : 'player_ship',
            texture : Luxe.resources.texture('assets/blue_ship.png'),
            pos : new Vector(0,0),
            depth : 2
        });
        player_ship.add(new ShipBrain('ship_brain'));

    } //create_player

} //GameState
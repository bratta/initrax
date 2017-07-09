module.exports = class Character {
  constructor(id, user_id, name, hit_points=0, initiative_bonus=0, roll_automatically=false,
              is_player=true, level=1, active=true, display_order=0) {

    this._id = id;
    this._user_id = user_id;
    this._name = name;
    this._hit_points = hit_points;
    this._initiative_bonus = initiative_bonus;
    this._roll_automatically = roll_automatically;
    this._is_player = is_player;
    this._level = level;
    this._active = active;
    this._display_order = display_order;
  }

  get id() {
    return this._id;
  }

  set id(id) {
    this._id = id;
  }

  get user_id() {
    return this._user_id;
  }

  set user_id(user_id) {
    this._user_id = user_id;
  }

  get name() {
    return this._name;
  }

  set name(name) {
    this._name = name;
  }

  get hit_points() {
    return this._hit_points;
  }

  set hit_points(hit_points) {
    this._hit_points = hit_points;
  }

  get initiative_bonus() {
    return this._initiative_bonus;
  }

  set initiative_bonus(initiative_bonus) {
    this._initiative_bonus = initiative_bonus;
  }

  get roll_automatically() {
    return this._roll_automatically;
  }

  set roll_automatically(roll_automatically) {
    this._roll_automatically = roll_automatically;
  }

  get is_player() {
    return this._is_player;
  }

  set is_player(is_player) {
    this._is_player = is_player;
  }

  get pc() {
    return this._is_player;
  }

  set pc(pc) {
    this._is_player = pc;
  }

  get npc() {
    return !this._is_player;
  }

  set npc(npc) {
    this._is_player = !npc;
  }

  get character_types() {
    return { pc: "pc", npc: "npc" };
  }

  get character_type() {
    return (this.is_player === true) ? this.character_types.pc : this.character_types.npc;
  }

  set character_type(character_type) {
    if (character_type === "pc") {
      this._is_player = true;
    } else {
      this._is_player = false;
    }
  }

  get level() {
    return this._level;
  }

  set level(level) {
    this._level = level;
  }

  get active() {
    return this._active;
  }

  set active(active) {
    this._active = active;
  }

  get display_order() {
    return this._display_order;
  }

  set display_order(display_order) {
    this._display_order = display_order;
  }

  to_json() {
    var json = {
      character: {
        id: this.id,
        user_id: this.user_id,
        name: this.name,
        hit_points: this.hit_points,
        initiative_bonus: this.initiative_bonus,
        roll_automatically: this.roll_automatically,
        is_player: this.is_player,
        level: this.level,
        active: this.active,
        display_order: this.display_order
      }
    }

    if (!this.id) {
      delete json.character.id
    }

    return json;
  }

  static from_json(json) {
    return new Character(json.id, json.user_id, json.name, json.hit_points, json.initiative_bonus, json.roll_automatically, json.is_player, json.level, json.active, json.display_order);
  }
}

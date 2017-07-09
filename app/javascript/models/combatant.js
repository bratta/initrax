var Character = require("models/character.js");

module.exports = class Combatant {
  constructor(id, user_id, hit_points=0, notes="", display_order=0, active=true, character=new Character(), calculated_roll=0) {
    this._id = id;
    this._user_id = user_id;
    this._hit_points = hit_points;
    this._notes = notes;
    this._display_order = display_order;
    this._active = active;
    this._character = character;
    this._calculated_roll = calculated_roll;
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

  get hit_points() {
    return this._hit_points;
  }

  set hit_points(hit_points) {
    this._hit_points = hit_points;
  }

  get notes() {
    return this._notes;
  }

  set notes(notes) {
    this._notes = notes;
  }

  get display_order() {
    return this._display_order;
  }

  set display_order(display_order) {
    this._display_order = display_order;
  }

  get active() {
    return this._active;
  }

  set active(active) {
    this._active = active;
  }

  get character() {
    return this._character;
  }

  set character(character) {
    this._character = character;
  }

  get calculated_roll() {
    return this._calculated_roll;
  }

  set calculated_roll(calculated_roll) {
    this._calculated_roll = calculated_roll;
  }

  to_json() {
    var json = {
      combatant: {
        id: this.id,
        user_id: this.user_id,
        hit_points: this.hit_points,
        notes: this.notes,
        display_order: this.display_order,
        active: this.active,
        calculated_roll: this.calculated_roll
      }
    };
    if (!this.id) {
      delete json.combatant.id;
    }
    return json;
  }

  static from_json(json) {
    var character = (json.character != null) ? Character.from_json(json.character) : new Character();
    return new Combatant(json.id, json.user_id, json.hit_points, json.notes, json.display_order, json.active, character, json.calculated_roll);
  }
};

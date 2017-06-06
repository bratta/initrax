class Combat {
  constructor(id, user_id, name, active=true, combatants=[]) {
    this._id = id;
    this._user_id = user_id;
    this._name = name;
    this._active = active;
    this._combatants = combatants;
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

  get combatants() {
    return this._combatants;
  }

  set combatants(combatants) {
    this._combatants = combatants;
  }

  to_json() {
    var json = {
      combat: {
        id: this.id,
        user_id: this.user_id,
        name: this.name,
        active: this.active,
        combatants_attributes: []
      }
    };
    if (!this.id) {
      delete json.combat.id;
    }
    this.combatants.forEach(function(combatant) {
      var combatant_json = combatant.to_json().combatant;
      combatant_json.character_id = combatant.character.id;
      json.combat.combatants_attributes.push(combatant_json);
    });
    return json;
  }

	static from_json(json) {
    var combatants = [];
    if (json.combatants && json.combatants.length > 0) {
      json.combatants.forEach(function(combatant) {
        combatants.push(Combatant.from_json(combatant));
      });
    }
    return new Combat(json.id, json.user_id, json.name, json.active, combatants);
	}
}

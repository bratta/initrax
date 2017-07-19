var Character = require("models/character.js");

describe("Character model", function() {
  describe("creation", function() {
    it("instantiates a new character model", () => {
      var character = new Character();
      expect(character).to.be.instanceOf(Character);
    });

    it("has a sane set of defaults", () => {
      var character = new Character();
      expect(character.hit_points).to.equal(0);
      expect(character.initiative_bonus).to.equal(0);
      expect(character.roll_automatically).to.be.false;
      expect(character.is_player).to.be.true;
      expect(character.level).to.equal(1);
      expect(character.active).to.be.true;
      expect(character.display_order).to.equal(0);
    });

    it("allows instantiation with default values", () => {
      var character = new Character(1, 1, "Testy McTestFace", 42, 13, true, false, 12, true, 1);
      expect(character.id).to.equal(1);
      expect(character.user_id).to.equal(1);
      expect(character.name).to.equal("Testy McTestFace");
      expect(character.hit_points).to.equal(42);
      expect(character.initiative_bonus).to.equal(13);
      expect(character.roll_automatically).to.be.true;
      expect(character.is_player).to.be.false;
      expect(character.level).to.equal(12);
      expect(character.active).to.be.true;
      expect(character.display_order).to.equal(1);
    });
  });

  describe("is_player", function() {
    var character;
    beforeEach(() => {
      character = new Character();
    });

    it("has the correct values for pc", () => {
      character.is_player = true;
      expect(character.pc).to.be.true;
      character.is_player = false;
      expect(character.pc).to.be.false;
    });

    it("has the correct values for npc", () => {
      character.is_player = true;
      expect(character.npc).to.be.false;
      character.is_player = false;
      expect(character.npc).to.be.true;
    });

    it("returns the correct character type", () => {
      character.is_player = true;
      expect(character.character_type).to.equal(character.character_types.pc);
      character.is_player = false;
      expect(character.character_type).to.equal(character.character_types.npc);
    });
  });

  describe("json", function() {
    it("formats the object as json", () => {
      var character = new Character(1, 1, "Testy McTestFace", 42, 13, true, false, 12, true, 1);
      var character_json = character.to_json();
      expect(character_json).to.exist;
      expect(character_json).to.include.all.keys("character");
      expect(character_json.character).to.include.all.keys("id", "user_id", "name", "hit_points",
        "initiative_bonus", "roll_automatically", "is_player", "level", "active", "display_order");
      expect(character_json.character.id).to.equal(1);
      expect(character_json.character.user_id).to.equal(1);
      expect(character_json.character.name).to.equal("Testy McTestFace");
      expect(character_json.character.hit_points).to.equal(42);
      expect(character_json.character.initiative_bonus).to.equal(13);
      expect(character_json.character.roll_automatically).to.be.true;
      expect(character_json.character.is_player).to.be.false;
      expect(character_json.character.level).to.equal(12);
      expect(character_json.character.active).to.be.true;
      expect(character_json.character.display_order).to.equal(1);
    });

    it("does not include the id key if no id is set", () => {
      var character = new Character();
      expect(character.to_json().character).to.not.have.all.keys("id");
      expect(character.to_json().character).to.include.all.keys("user_id", "name", "hit_points",
        "initiative_bonus", "roll_automatically", "is_player", "level", "active", "display_order");
    });

    it("creates a new Character from json", () => {
      var json = {
        id: 1,
        user_id: 1,
        name: "Testy McTestFace",
        hit_points: 42,
        initiative_bonus: 13,
        roll_automatically: true,
        is_player: false,
        level: 12,
        active: true,
        display_order: 1
      };
      var character = Character.from_json(json);
      expect(character.id).to.equal(1);
      expect(character.user_id).to.equal(1);
      expect(character.name).to.equal("Testy McTestFace");
      expect(character.hit_points).to.equal(42);
      expect(character.initiative_bonus).to.equal(13);
      expect(character.roll_automatically).to.be.true;
      expect(character.is_player).to.be.false;
      expect(character.level).to.equal(12);
      expect(character.active).to.be.true;
      expect(character.display_order).to.equal(1);
    });
  });
});

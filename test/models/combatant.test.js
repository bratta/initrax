var Combatant = require("models/combatant.js");
var Character = require("models/character.js");

describe("Combatant model", () => {
  describe("creation", function() {
    it("instantiates a new combatant model", () => {
      var combatant = new Combatant();
      expect(combatant).to.be.instanceOf(Combatant);
    });

    it("has a sane set of defaults", () => {
      var combatant = new Combatant();
      expect(combatant.hit_points).to.equal(0);
      expect(combatant.notes).to.be.empty;
      expect(combatant.display_order).to.equal(0);
      expect(combatant.active).to.be.true;
      expect(combatant.character).to.not.be.empty;
      expect(combatant.calculated_roll).to.equal(0);
    });

    it("allows instantiation with default values", () => {
      var character = new Character(1, 1, "Testy McTestFace", 42, 13, true, false, 12, true, 1);
      var combatant = new Combatant(1, 1, 42, "Notes", 0, true, character, 21);
      expect(combatant.id).to.equal(1);
      expect(combatant.user_id).to.equal(1);
      expect(combatant.notes).to.equal("Notes");
      expect(combatant.display_order).to.equal(0);
      expect(combatant.active).to.be.true;
      expect(combatant.character).to.not.be.empty;
      expect(combatant.character.name).to.equal("Testy McTestFace");
    });
  });

  describe("json", function() {
    it("formats the object as json", () => {
      // Character is not needed for generating JSON as the actual character object
      // is not persisted back to the database using this json call
      var combatant = new Combatant(1, 1, 42, "Notes", 0, true, null, 21);
      var combatant_json = combatant.to_json();
      expect(combatant_json).to.exist;
      expect(combatant_json).to.include.all.keys("combatant");
      expect(combatant_json.combatant).to.include.all.keys("id", "user_id", "hit_points", "notes", "display_order", "active", "calculated_roll");
      expect(combatant_json.combatant.id).to.equal(1);
      expect(combatant_json.combatant.user_id).to.equal(1);
      expect(combatant_json.combatant.hit_points).to.equal(42);
      expect(combatant_json.combatant.notes).to.equal("Notes");
      expect(combatant_json.combatant.display_order).to.equal(0);
      expect(combatant_json.combatant.active).to.be.true;
      expect(combatant_json.combatant.calculated_roll).to.equal(21);
    });

    it("does not include the id key if no id is set", () => {
      var combatant = new Combatant();
      expect(combatant.to_json().combatant).to.not.have.all.keys("id");
      expect(combatant.to_json().combatant).to.include.all.keys("user_id", "hit_points", "notes", "display_order", "active", "calculated_roll");
    });

    it("creates a new Combatant from json", () => {
      var json = {
        id: 1,
        user_id: 1,
        hit_points: 42,
        notes: "Notes",
        display_order: 0,
        active: true,
        character: {
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
        },
        calculated_roll: 21
      };
      var combatant = Combatant.from_json(json);
      expect(combatant.id).to.equal(1);
      expect(combatant.user_id).to.equal(1);
      expect(combatant.hit_points).to.equal(42);
      expect(combatant.notes).to.equal("Notes");
      expect(combatant.display_order).to.equal(0);
      expect(combatant.active).to.be.true;
      expect(combatant.calculated_roll).to.equal(21);
      expect(combatant.character).to.not.be.empty;
      expect(combatant.character.name).to.equal("Testy McTestFace");
    });
  });
});
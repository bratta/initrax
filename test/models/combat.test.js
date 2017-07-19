var Combat = require("models/combat.js");
var Combatant = require("models/combatant.js");

describe("Combat model", () => {
  describe("creation", function() {
    it("instantiates a new character model", () => {
      var combat = new Combat();
      expect(combat).to.be.instanceOf(Combat);
    });

    it("has a sane set of defaults", () => {
      var combat = new Combat();
      expect(combat.active).to.be.true;
      expect(combat.combatants).to.be.empty;
    });

    it("allows instantiation with default values", () => {
      var combatants = [
        sinon.stub(), sinon.stub()
      ];
      var combat = new Combat(1, 1, "Combat 1", true, combatants);
      expect(combat.id).to.equal(1);
      expect(combat.user_id).to.equal(1);
      expect(combat.name).to.equal("Combat 1");
      expect(combat.active).to.be.true;
      expect(combat.combatants).to.not.be.empty;
      expect(combat.combatants.length).to.equal(2);
    });
  });

  describe("json", function() {
    it("formats the object as json", () => {
      var combatant = { to_json: () => {}, character: { id: 1 } };
      var combatantMock = sinon.mock(combatant);
      combatantMock.expects("to_json").once().returns({ combatant: { } });
      var combatants = [ combatant ];
      var combat = new Combat(1, 1, "Combat 1", true, combatants);

      var combat_json = combat.to_json();
      expect(combat_json).to.exist;
      expect(combat_json).to.include.all.keys("combat");
      expect(combat_json.combat).to.include.all.keys("id", "user_id", "name", "active", "combatants_attributes");
      expect(combat_json.combat.id).to.equal(1);
      expect(combat_json.combat.user_id).to.equal(1);
      expect(combat_json.combat.name).to.equal("Combat 1");
      expect(combat_json.combat.combatants_attributes.length).to.equal(1);
      expect(combat_json.combat.combatants_attributes[0].character_id).to.equal(1);
    });

    it("does not include the id key if no id is set", () => {
      var combat = new Combat();
      expect(combat.to_json().combat).to.not.have.all.keys("id");
      expect(combat.to_json().combat).to.include.all.keys("user_id", "name", "active", "combatants_attributes");
    });

    it("creates a new Combat from json", () => {
      var combatantMock = sinon.mock(Combatant);
      combatantMock.expects("from_json").once().returns({ id: 1 });
      var json = {
        id: 1,
        user_id: 1,
        name: "Combat 1",
        active: true,
        combatants: [{}]
      };
      var combat = Combat.from_json(json);
      expect(combat.id).to.equal(1);
      expect(combat.user_id).to.equal(1);
      expect(combat.name).to.equal("Combat 1");
      expect(combat.active).to.be.true;
      expect(combat.combatants.length).to.equal(1);
      expect(combat.combatants[0].id).to.equal(1);
      combatantMock.restore();
    });
  });
});
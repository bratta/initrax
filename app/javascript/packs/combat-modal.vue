<template>
<div class="modal fade in" id="combatModal" tabindex="-1" role="dialog" aria-labelledby="combatModalLabel" style="display: block;">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" aria-label="Close" @click="$emit('close')"><span aria-hidden="true">×</span></button>
        <h4 class="modal-title form-inline" id="combatModalLabel">
          Add to:&nbsp;
          <select class="form-control" v-model="selectedCombat" @change="disableNewCombatName">
            <option></option>
            <option v-for="combat in combatNames" v-bind:key="combat.id" v-bind:value="combat.id">
              {{ combat.name }}
            </option>
          </select> &nbsp;or&nbsp;
          <input type="text" placeholder="New Encounter" v-model="newCombatName" @change="disableCombatName">
        </h4>
      </div>
      <div class="modal-body">
        <table class="table table-striped">
          <thead>
            <tr>
              <th>Character</th>
              <th>Type</th>
              <th>Initiative Roll</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="combatant in sortedCombatants" v-bind:key="combatant.character.id">
              <td>{{combatant.character.name}}</td>
              <td v-if="combatant.character.is_player"><span class="badge">PC</span></td>
              <td v-else><span class="badge">NPC</span></td>
              <td>
                <input type="number" class="form-control" v-model="initiativeRolls[combatant.character.id]" :disabled="combatant.character.roll_automatically" :data-vv-name="'initiative_roll-'+combatant.character.id" data-vv-as="Initiative Roll" v-validate="'numeric|min_value:1'" :class="{'input': true, 'is-danger': validationErrors.has('initiative_roll-'+combatant.character.id)}">
                <span v-show="validationErrors.has('initiative_roll-'+combatant.character.id)" class="help is-danger">{{ validationErrors.first('initiative_roll-'+combatant.character.id) }}</span>
              </td>
              <td><label><input type="checkbox" v-model="combatant.character.roll_automatically" @click="checkAutomaticRoll(combatant)"> Roll Automatically</label></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" @click="saveCombat">Save changes</button>
        <button type="button" class="btn btn-warning" @click="$emit('close')">Cancel</button>
      </div>
    </div>
  </div>
</div>
</template>

<script>

var Combat = require("models/combat.js");
var Combatant = require("models/combatant.js");

export default {
  props: ["characters"],

  data: function () {
    return {
      selectedCombat: null,
      newCombatName: null,
      combatants: [],
      initiativeRolls: {},
      combatNames: []
    };
  },

  created: function() {
    this.fetchCombatNames();
    this.populateCombatants();
  },

  methods: {
    fetchCombatNames: function() {
      const vm = this;
      axios.get("/api/combats/names.json")
        .then(function(response) {
          vm.combatNames = response.data;
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    },

    populateCombatants: function() {
      const vm = this;
      _.each(this.characters, function(character) {
        var newCombatant = new Combatant();
        newCombatant.user_id = vm.current_user.id;
        newCombatant.character = character;
        newCombatant.hit_points = character.hit_points;
        vm.combatants.push(newCombatant);
        vm.initiativeRolls[newCombatant.character.id] = "";
      });
    },

    checkAutomaticRoll: function(combatant) {
      if (combatant.character.roll_automatically) {
        this.initiativeRolls[combatant.character.id] = "";
      }
    },

    disableNewCombatName: function() {
      if (this.selectedCombat) {
        this.newCombatName = "";
      }
    },

    disableCombatName: function() {
      if (this.newCombatName) {
        this.selectedCombat = "";
      }
    },

    saveCombat: function() {
      this.$validator.validateAll();
      if (this.validationErrors.any()) {
        this.errorToast("Please fix the validation errors before saving.");
      } else {
        if (this.newCombatName) {
          this.createCombat();
        } else if (this.selectedCombat) {
          this.updateCombat();
        } else {
          this.$emit("close");
        }
      }
    },

    rollInitiative: function(combatant) {
      var roll = _.toNumber(this.initiativeRolls[combatant.character.id]);
      if (combatant.character.roll_automatically) {
        roll = Math.floor(Math.random() * 19) + 1;
      }
      var calculated_roll = roll + combatant.character.initiative_bonus;
      combatant.calculated_roll = calculated_roll;
      return calculated_roll;
    },

    setInitiativeOrder: function(combatants) {
      const vm = this;
      // Roll for initiative
      _.each(combatants, function(combatant) {
        if (!combatant.calculated_roll) {
          vm.rollInitiative(combatant);
        }
      });
      // Now reset the display orders so that they are
      // consecutive.
      _.each(_.orderBy(combatants, ["calculated_roll"], ["desc"]), function(combatant, index) {
        combatant.display_order = index;
      });
    },

    updateCombat: function() {
      const vm = this;
      axios.get("/api/combats/"+vm.selectedCombat+".json")
        .then(function(response) {
          var combat = Combat.from_json(response.data);
          _.each(vm.combatants, function(combatant) {
            combat.combatants.push(combatant);
          });
          vm.setInitiativeOrder(combat.combatants);
          axios.put("/api/combats/"+vm.selectedCombat, combat.to_json())
            .then(function() {
              vm.eventHub.$emit("combat-saved");
              vm.$emit("close");
            })
            .catch(function(e) {
              vm.errors.push(e);
            });
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    },

    createCombat: function() {
      const vm = this;
      var combat = new Combat(null, vm.current_user.id, this.newCombatName, true, vm.combatants);
      vm.setInitiativeOrder(combat.combatants);
      axios.post("/api/combats", combat.to_json())
        .then(function() {
          vm.eventHub.$emit("combat-saved");
          vm.$emit("close");
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    }
  },

  computed: {
    sortedCombatants: function() {
      const vm = this;
      return _.orderBy(vm.combatants, ["character.is_player", "character.name"], ["desc", "asc"]);
    }
  }
};
</script>

<style scoped>
</style>

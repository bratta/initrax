<template>
  <section>
		<div class="col-md-2 initrax-column" v-for="combat of combats" v-bind:key="combat.id">
          <div class="column-header">
            <h3>{{combat.name}}</h3>
            <button type="button" class="btn btn-xs btn-danger" @click="deleteCombat(combat)">X</button>
          </div>
          <div class="scrollable">
            <ul class="list-unstyled draggable" v-sortable="{ onUpdate: reorderCombatants(combat) }">
              <li v-for="combatant of combat.combatants" class="panel panel-default"
                  v-bind:key="combatant.id">
                <div class="panel-body form-inline">
                  <button type="button" class="close" @click="deleteCombatant(combatant)">×</button>
                    <strong>{{combatant.character.name}}</strong>
										<span v-if="combatant.character.is_player" class="badge">PC</span>
                    <span v-else="!combatant.character.is_player" class="badge">NPC</span>
                    (Initiative: {{combatant.calculated_roll}})<br>
                    <strong>HP:</strong> {{combatant.hit_points}}/{{combatant.character.hit_points}}
									  <strong>Level/CR:</strong> {{combatant.character.level}}
                    <input type="text" class="form-control" placeholder="Notes" v-model="combatant.notes"><br>
                    <div>
                      <div class="col-md-6">
                        <input type="number" class="form-control" placeholder="Damage" v-model="damageCounter[combatant.id]">
                      </div>
                      <div class="col-md-6">
                        <button class="btn btn-danger" @click="applyChanges(combatant)">Apply</button>
                      </div>
                    </div>
                </div>
              </li>
            </ul>
          </div>
        </div>
  </section>
</template>

<script>
export default {
  data: function() {
    return {
      combats: [],
      damageCounter: {}
    }
  },

  created: function() {
    this.eventHub.$on('combat-saved', this.fetchCombats);
    this.fetchCombats();
  },

  methods: {
    fetchCombats: function() {
      const vm = this;
      vm.combats = [];
      axios.get('/api/combats.json')
        .then(function(response) {
          _.each(response.data, function(combat) {
            vm.combats.push(Combat.from_json(combat));
          });
          _.each(_.flatten(_.map(vm.combats, "combatants"), true), function(combatant) {
            vm.damageCounter[combatant.id] = '';
          });
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    },
    reorderCombatants: function(combat) {
      const vm = this;
      return function(e) {
        combat.combatants.splice(e.newIndex, 0, combat.combatants.splice(e.oldIndex, 1)[0]);
        _.each(combat.combatants, function(combatant, index) {
          combatant.display_order = index;
        });
        axios.post('/api/combatants/order', {
          combatants: { order: vm.getCombatantsDisplayOrder(combat) }
        })
          .catch(function(e) {
            vm.errors.push(e);
          });
      }
    },
    getCombatantsDisplayOrder: function(combat) {
      return _.map(combat.combatants, function(combatant) {
        return { id: combatant.id, display_order: combatant.display_order };
      });
    },
    applyChanges: function(combatant) {
      const vm = this;
      var damage = parseInt(vm.damageCounter[combatant.id]) || 0;
      combatant.hit_points = combatant.hit_points - damage;
      vm.damageCounter[combatant.id] = '';
      axios.put('/api/combatants/'+combatant.id, combatant.to_json())
        .catch(function(e) {
          vm.errors.push(e);
        });
    },
    deleteCombatant: function(combatant) {
      const vm = this;
      axios.delete('/api/combatants/'+combatant.id+'.json')
        .then(function(response) {
          vm.eventHub.$emit('combat-saved');
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    },
    deleteCombat: function(combat) {
      const vm = this;
      axios.delete('/api/combats/'+combat.id+'.json')
        .then(function(response) {
          vm.eventHub.$emit('combat-saved');
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    }
  }
}
</script>

<style scoped>
</style>

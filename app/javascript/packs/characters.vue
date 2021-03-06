<template>
  <div>
   <div class="column-header">
     <h3>Characters</h3>
     <button type="button" class="btn btn-xs btn-primary" @click="showCombatModal=true">+ Combat</button>
     <combat-modal v-if="showCombatModal" :characters.sync="selectedCharacters" @close="showCombatModal=false"></combat-modal>
    </div>
    <br>
    <div class="btn-group btn-group-justified">
      <a class="btn btn-primary" @click="selectAll">All</a>
      <a class="btn btn-primary" @click="selectPC">PC</a>
      <a class="btn btn-primary" @click="selectNPC">NPC</a>
      <a class="btn btn-primary" @click="clearSelected">None</a>
    </div>
    <br>
    <div class="scrollable">
      <ul class="list-unstyled" v-sortable="{ onUpdate: reorderCharacters }">
        <li v-for="character of characters" class="panel panel-default"
            v-bind:key="character.id" @click="clickHandler(character)"
            v-bind:class="isSelected(character)">
          <div class="panel-body">
            <strong>{{character.name}}</strong>
            <span v-if="character.is_player" class="badge">PC</span>
            <span v-else class="badge">NPC</span><br>
            <strong>HP:</strong> {{character.hit_points}}
            <strong>Init:</strong> {{character.initiative_bonus}}
            <strong>Level:</strong> {{character.level}}
          </div>
        </li>
      </ul>
      <button type="button" class="btn btn-block btn-success add-btn" @click="addNewCharacter">Add Character</button>
      <character-modal v-if="showCharacterModal" :user.sync="editCharacter" @close="showCharacterModal=false" @changed-saved="changesSaved"></character-modal>
    </div>
  </div>
</template>

<script>
import CharacterModal from "./character-modal.vue";
import CombatModal from "./combat-modal.vue";
var Character = require("models/character.js");

export default {
  data: function () {
    return {
      characters: [],
      showCharacterModal: false,
      showCombatModal: false,
      editCharacter: new Character(null, this.$parent.current_user.id),
      selectedCharacters: [],
      delay: 700,
      clicks: 0,
      timer: null
    };
  },

  components: {
    "character-modal": CharacterModal,
    "combat-modal": CombatModal
  },

  created: function() {
    this.fetchCharacters();
  },

  methods: {
    clickHandler: function(character) {
      const vm = this;
      vm.clicks++;
      if (vm.clicks === 1) {
        vm.timer = setTimeout(function() {
          vm.toggleSelection(character);
          vm.clicks = 0;
        }, vm.delay);
      } else {
        clearTimeout(vm.timer);
        vm.editExistingCharacter(character);
        this.clicks = 0;
      }
    },
    fetchCharacters: function() {
      const vm = this;
      axios.get("/api/characters.json")
        .then(function(response) {
          vm.characters = [];
          _.each(response.data, function(character) {
            vm.characters.push(Character.from_json(character));
          });
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    },
    changesSaved: function() {
      this.fetchCharacters();
    },
    addNewCharacter: function() {
      this.editCharacter = new Character(),
      this.showCharacterModal = true;
    },
    editExistingCharacter: function(character) {
      this.editCharacter = character;
      this.showCharacterModal = true;
    },
    toggleSelection: function(character) {
      if (_.some(this.selectedCharacters, character)) {
        _.remove(this.selectedCharacters, character);
      } else {
        this.selectedCharacters.push(character);
      }
      this.$forceUpdate();
    },
    reorderCharacters: function(e) {
      const vm = this;
      vm.characters.splice(e.newIndex, 0, vm.characters.splice(e.oldIndex, 1)[0]);
      _.each(vm.characters, function(character, index) {
        character.display_order = index;
      });
      axios.post("/api/characters/order", {
        characters: { order: vm.getCharactersDisplayOrder() }
      })
        .catch(function(e) {
          vm.errors.push(e);
        });
    },

    getCharactersDisplayOrder: function() {
      return _.map(this.characters, function(character) {
        return { id: character.id, display_order: character.display_order };
      });
    },

    isSelected: function(character) {
      if (_.some(this.selectedCharacters ,character)) {
        return ["selected"];
      } else {
        return [];
      }
    },

    clearSelected: function() {
      this.selectedCharacters = [];
    },

    selectCharacter: function(isPlayer) {
      const vm = this;
      _.each(this.characters, function(character) {
        if (character.is_player == isPlayer && !vm.isSelected(character)[0]) {
          vm.selectedCharacters.push(character);
        }
      });
    },

    selectPC: function() {
      this.selectCharacter(true);
    },

    selectNPC: function() {
      this.selectCharacter(false);
    },

    selectAll: function() {
      const vm = this;
      this.selectedCharacters = [];
      _.each(this.characters, function(character) {
        vm.selectedCharacters.push(character);
      });
    },
  }
};
</script>

<style scoped>
</style>

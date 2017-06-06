<template>
<div class="modal fade in" id="characterModal" tabindex="-1" role="dialog" aria-labelledby="characterModalLabel" style="display: block;">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" aria-label="Close" @click="$emit('close')"><span aria-hidden="true">×</span></button>
        <h4 class="modal-title form-inline" id="characterModalLabel">
          Add a Character
        </h4>
      </div>
      <div class="modal-body">
        <form lpformnum="1">
          <div class="row">
            <div class="col-md-8">
              <div class="form-group">
                <label for="name">Character Name</label>
                <input v-model="user.name" type="text" class="form-control" id="name" placeholder="Some Goofy Name">
              </div>
            </div>
            <div class="col-md-4">
              <div class="form-group">
                <label for="type">Character Type</label><br>
                <radio :values="user.character_types" :selected.sync="user.character_type" default="user.character_type"></radio>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="form-group">
                <label for="level">Level/Challenge Rating</label>
                <input v-model="user.level" type="number" class="form-control" id="level">
              </div>
              <div class="form-group">
                <label for="hp">Hit Points</label>
                <input v-model="user.hit_points" type="number" class="form-control" id="hp">
              </div>
              <div class="form-group">
                <label>
                  <input type="checkbox" v-model="user.roll_automatically" />
                  Roll Automatically
                </label>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-group">
                <label for="initiative">Initiative Rating</label>
                <input v-model="user.initiative_bonus" type="number" class="form-control" id="initiative">
              </div>
              <div class="form-group" v-if="user.id">
                <input type="hidden" v-model="user.id" />
                <label for="delete">Delete Character</label><br />
                <button class="btn btn-danger" id="delete" @click="deleteCharacter">Delete Character</button>
              </div>
              <div class="form-group" v-else>
                <label for="quantity">Quantity</label>
                <input type="number" class="form-control" id="quantity" v-model="quantity">
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-warning" @click="$emit('close')">Cancel</button>
        <button type="button" class="btn btn-primary" @click="saveChanges(quantity)">Save changes</button>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import Radio from './radio.vue'

export default {
  props: ['user'],

  data: function () {
    return {
      quantity: 1,
      errors: []
    }
  },

  components: {
    'radio': Radio
  },

  methods: {
    saveChanges: function(quantity) {
      if (this.user.id) {
        this.updateCharacter();
      } else {
        this.createCharacter(quantity);
      }
    },
    createCharacter: function(quantity) {
      const vm = this;
      quantity = _.toInteger(quantity);
      quantity = (quantity < 1) ? 1 : quantity;
      var characters = [];
      _.times(quantity, function() {
        characters.push(axios.post('/api/characters', vm.user.to_json()));
      });
      axios.all(characters)
        .then(function() {
          vm.$emit('changed-saved');
          vm.$emit('close');
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    },
    updateCharacter: function() {
      const vm = this;
      axios.put('/api/characters/'+vm.user.id, vm.user.to_json())
        .then(function() {
          vm.$emit('changed-saved');
          vm.$emit('close');
        })
        .catch(function(e) {
          vm.errors.push(e);
        });
    },
    deleteCharacter: function() {
      const vm = this;
      axios.delete('/api/characters/'+vm.user.id)
        .then(function() {
          vm.$emit('changes-saved');
          vm.$emit('close');
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


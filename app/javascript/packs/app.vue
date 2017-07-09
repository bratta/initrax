<template>
  <div class="initrax-container container-fluid">
    <div class="row full-height-row">
      <div class="col-md-2 initrax-column">
        <div class="column-header">
          <h3>Initrax</h3>
          <a href="/users/sign_out" data-method="delete" class="btn btn-xs btn-primary">Logout</a>
        </div>
        <div class="scrollable">
          <div class="user-info">
            <div class="col-md-3">
              <img :src="current_user.avatar_url">
            </div>
            <div class="col-md-9 user-links">
              <p>{{ current_user.username }}</p>
              <p><a href="/users/edit">Edit Profile</a></p>
            </div>
          </div>
          <div class="welcome-message" v-html="message">
          </div>
        </div>
      </div>
      <div class="col-md-2 initrax-column">
        <characters></characters>
      </div>
      <combats></combats>
    </div>
  </div>
</template>

<script>
import Characters from "./characters.vue";
import Combats from "./combats.vue";

export default {
  components: {
    characters: Characters,
    combats: Combats
  },
  data: function () {
    return {
      message: "<p><strong>Welcome to Initrax!</strong></p><p>Here you can track your initiative with style! This system is compatible with Pathfinder, DND, or other initiative-based role-playing games. Add your characters (both players and non-playing characters), and use this tool to keep track of turn order for your combat sessions.</p>"
    };
  }
};
</script>

<style scoped>
</style>

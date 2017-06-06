/* eslint no-console: 0 */

import Vue from 'vue/dist/vue.esm'
import App from './app.vue'
import Sortable from 'vue-sortable'
import Characters from './characters.vue'
import Combats from './combats.vue'

Vue.use(Sortable);
Vue.component('characters', Characters);
Vue.component('combats', Combats);

const eventHub = new Vue();

Vue.mixin({
  data: function() {
    return {
      eventHub: eventHub,
      current_user: window.current_user || { id: 0, username: "Guest", email: "" }
    }
  }
});

var initializeInitrax = function() {
  document.body.appendChild(document.createElement('initrax'))
  const app = new Vue({
    el: 'initrax',
    template: '<app/>',
    components: {
      'app': App
    }
  })
};

document.addEventListener('DOMContentLoaded', () => {
  initializeInitrax();
});

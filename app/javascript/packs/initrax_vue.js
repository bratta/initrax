/* eslint no-console: 0 */

import Vue from 'vue/dist/vue.esm'
import App from './app.vue'
import Sortable from 'vue-sortable'
import Toast from 'vue-easy-toast'
import VeeValidate from 'vee-validate'

Vue.use(Sortable);
Vue.use(Toast);

const eventHub = new Vue();
const veeValidateConfig = {
  errorBagName: 'validationErrors',
  fieldsBagName: 'validationFields',
};
Vue.use(VeeValidate, veeValidateConfig);

Vue.mixin({
  data: function() {
    return {
      eventHub: eventHub,
      current_user: window.current_user || { id: 0, username: "Guest", email: "" },
      errors: []
    }
  },
  methods: {
    errorToast: function(message, exceptionObject) {
      if (console && console.error) {
        console.error("Received exception from application:", exceptionObject);
      }
      this.$toast(message, {
        className: 'et-alert',
        horizontalPosition: 'center',
        verticalPosition: 'top',
        transition: 'slide-left'
      });
    },
    handleError: function(error) {
      var message = "There was an error with your request";
      if (error) {
        message += "<br />\n(Error:";
        if (error.response) {
          message += ` ${error.response.status} ${error.response.statusText}`;
        }
        if (error.message) {
          message += ` ${error.message}`
        }
        message += ")";
      }
      this.errorToast(message, error);
    }
  },
  watch: {
    errors: function() {
      const vm = this;
      if (vm.errors && vm.errors.length > 0) {
        _.each(vm.errors, function(error) {
          vm.handleError(error);
        });
        this.errors = [];
      }
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

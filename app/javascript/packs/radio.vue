<template>
  <div class="btn-group">
    <button
      type="button"
      v-for="(key, val) in values"
      @click="changeSelectedVal(key)"
      :class="['btn', { 'btn-info': selected === key, 'btn-default': selected !== key }]"
    >{{ val }}</button>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
    };
  },
  props: ["values", "selected", "default"],
  ready: function () {
    this.$emit("update:selected", this.default);
  },
  methods: {
    changeSelectedVal: function(val) {
      this.$emit("update:selected", val);
    }
  }
};
</script>

<style scoped>
</style>

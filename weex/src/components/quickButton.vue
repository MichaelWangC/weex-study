<template>
  <div
    :style="{ backgroundColor: backgroundColor }"
    class="container"
    @click="onclickitem">
    <image
      :src="icon"
      class="tab-icon"></image>
    <text
      :style="{ color: titleColor }"
      class="tab-text">{{title}}</text>
  </div>  
</template>

<style scoped>
  .container {
    flex: 1; 
    flex-direction: column; 
    align-items:center; 
    justify-content:center; 
  }
  .tab-icon {
    margin-top: 10; 
    width: 50; 
    height: 50;
  }
  .tab-text {
    margin-top: 5; 
    text-align: center;  
    font-size: 20;
  }
</style>

<script>
  module.exports = {
    props: {
      index: { default: 0 },
      title: { default: '' },
      titleColor: { default: '#000000' },
      icon: { default: '' },
      backgroundColor: { default: '#ffffff' }
    },
    methods: {
      onclickitem: function (e) {
        var params = {
          index: this.index
        };
        this.$emit('quickBtnOnClick', params);
      }
    }
  }
</script>
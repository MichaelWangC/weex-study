<template>
  <div
    :style="{ backgroundColor: backgroundColor }"
    class="container"
    @click="onclickitem">
    <div
      class="top-line"></div>
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
    height: 120;
  }
  .top-line {
    position: absolute; 
    top: 0; 
    left: 0; 
    right: 0; 
    height: 2;
    background-color: #d6d7dc
  }
  .tab-icon {
    margin-top: 10; 
    width: 60; 
    height: 60;
  }
  .tab-text {
    margin-top: 5; 
    text-align: center;  
    font-size: 25;
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
        this.$emit('tabItemOnClick', params);
      }
    }
  }
</script>
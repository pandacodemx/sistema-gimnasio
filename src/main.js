import Vue from "vue";
import App from "./App";
import router from "./router";
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";
import "@mdi/font/css/materialdesignicons.css";

Vue.use(Vuetify);

const vuetify = new Vuetify({
  theme: {
    dark: true,
    themes: {
      dark: {
        background: "#121212",
        primary: "#2196F3",
        secondary: "#00BFA5",
        accent: "#82B1FF",
        error: "#F44336",
        info: "#2196F3",
        success: "#4CAF50",
        warning: "#FFC107",
        blackbox: "#010100",
        white: "#FFFFFF"
      }
    }
  }
});

Vue.config.productionTip = false;

new Vue({
  el: "#app",
  router,
  vuetify,
  components: { App },
  template: "<App/>"
});

import Vue from "vue";
import App from "./App";
import router from "./router";
import store from "./store";
import Vuetify from "vuetify";
import "vuetify/dist/vuetify.min.css";
import "@mdi/font/css/materialdesignicons.css";
import { defaultTheme } from "./theme";

Vue.use(Vuetify);

const vuetify = new Vuetify({
  theme: {
    dark: true,
    themes: {
      dark: { ...defaultTheme }
    }
  }
});

Vue.config.productionTip = false;

new Vue({
  el: "#app",
  router,
  store,
  vuetify,
  components: { App },
  template: "<App/>"
});

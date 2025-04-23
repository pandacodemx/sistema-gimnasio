<template>
  <section>
    <div class="row">
      <div
        class="col-sm-6 col-lg-3 col-12"
        v-for="(item, index) in cartas"
        :key="index"
      >
        <div
          class="
            v-card--material
            pa-3
            v-card--material-stats
            v-card v-sheet
            theme--dark
            v-card--material--has-heading
            
          "
        >
          <div class="d-flex grow flex-wrap">
            <div
              :class="item.color"
              class="
                text-left
                v-card--material__heading
                mb-n6
                v-sheet
                elevation-6
                pa-4
                rounded-lg
              "
              style="max-height: 70px; width: auto"
            >
              <v-icon large color="white">
                {{ item.icono }}
              </v-icon>
            </div>
            <div class="ml-6">
              <div class="ml-auto text-left">
                <div class="body-3 grey--text font-weight-light">
                  {{ item.nombre }}
                </div>
                <h3 class="display-1 font-weight-bold text--primary">
                  {{ item.total }}
                  <small></small>
                </h3>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>


////////////SCRIPT////////////////
<script>
export default {
  name: "CartasPersonalizadas",
  props: ["cartas"],
};
</script>

<template>
    <section>
        <h3 class="text-h6 mb-4">
            <v-icon left>{{ icono }}</v-icon>
            {{ titulo }}
        </h3>
        <div class="row">
            <div class="col-sm-6 col-lg-3 col-12" v-for="(item, index) in totales" :key="index">
                <div
                    class="v-card--material pa-3 v-card--material-stats v-card v-sheet theme--dark v-card--material--has-heading ">
                    <div class="d-flex grow flex-wrap">
                        <div :class="color"
                            class="rounded-lg text-start v-card--material__heading mb-n6 v-sheet elevation-6 pa-4"
                            style="max-height: 70px; width: auto;">
                            <v-icon large color="white">
                                {{ icono }}
                            </v-icon>
                        </div>
                        <div class="ml-6">
                            <div class="ml-auto text-left">
                                <div class="body-3 warning--text font-weight-light">
                                    {{ item.nombre }}
                                </div>
                                <h3 class="display-1 font-weight-bold">
                                    {{ item.total.toFixed(2) }}
                                    <small class="text-caption">({{ item.cantidad }} pagos)</small>
                                </h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
<script>
export default {
    name: "CartasTotales",
    props: ["totales", "titulo", "icono", "color"]
}
</script>

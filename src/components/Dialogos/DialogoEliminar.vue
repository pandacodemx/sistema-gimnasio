<template>
  <v-card>
    <v-card-title 
      >Se eliminara {{ nombre }}</v-card-title
    >
    <v-card-actions>
      <v-spacer></v-spacer>
      <v-btn color="error darken-1" text @click="cerrarDialogo">Cancelar</v-btn>
      <v-btn color="white" text @click="eliminar">Aceptar</v-btn>
      <v-spacer></v-spacer>
    </v-card-actions>
  </v-card>
</template>
<script>
export default {
    name: "DialogoEliminar",
    props: ["nombre"],

    methods: {
        cerrarDialogo(){
            this.$emit("cancelar", false)
        },

        eliminar(){
            this.$emit("eliminar", true)
        }
    }
}
</script>
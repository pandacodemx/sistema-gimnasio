<template>
  <div>
    <v-stepper v-model="e6" vertical>
      <v-stepper-step :complete="e6 > 1" step="1">
        Datos personales
        <small class="mt-2">Escribe los datos personales</small>
      </v-stepper-step>

      <v-stepper-content step="1">
        <v-form ref="form" v-model="formDatosPersonales">
          <v-card class="mb-12 pa-6">
            <v-text-field label="Nombre completo" :rules="reglasNombre" v-model="datosPersonales.nombre">
            </v-text-field>
            <v-text-field label="Teléfono / Celular" :rules="reglasTelefono" v-model="datosPersonales.telefono">
            </v-text-field>
            <v-text-field label="Domicilio" :rules="reglasDireccion" v-model="datosPersonales.direccion">
            </v-text-field>
            <v-text-field label="Edad" :rules="reglasEdad" v-model="datosPersonales.edad">
            </v-text-field>
          </v-card>
          <v-btn color="primary" @click="e6 = 2" :disabled="!formDatosPersonales">
            Continuar
          </v-btn>
          <v-btn text to="/miembros"> Cancelar </v-btn>
        </v-form>
      </v-stepper-content>

      <v-stepper-step :complete="e6 > 2" step="2">
        Datos de contacto
        <small class="mt-2">Rellena los siguientes campos en caso de algun accidente.</small>
      </v-stepper-step>

      <v-stepper-content step="2">
        <v-form ref="form" v-model="formDatosContacto">
          <v-card class="mb-12 pa-6">
            <v-switch v-model="datosContacto.sufreEnfermedad" label="¿Sufre alguna enfermedad crónica?"></v-switch>
            <v-text-field label="Escribe las enfermedades." v-if="datosContacto.sufreEnfermedad"
              v-model="datosContacto.enfermedad"></v-text-field>

            <v-switch v-model="datosContacto.tieneSeguro" label="¿Cuenta con seguro medico?"></v-switch>
            <v-text-field label="Escribe las institución medica." v-if="datosContacto.tieneSeguro"
              v-model="datosContacto.institucion"></v-text-field>
            <v-text-field label="NSS/Numero de afiliación" v-if="datosContacto.tieneSeguro"
              v-model="datosContacto.afiliacion"></v-text-field>
            <small class="mt-2">Contacto de emergencia.</small>
            <v-text-field label="Nombre de contacto" :rules="reglasForm" v-model="datosContacto.nombreContacto">
            </v-text-field>
            <v-text-field label="Teléfono" :rules="reglasForm" v-model="datosContacto.telefonoContacto">
            </v-text-field>
          </v-card>
          <v-btn color="primary" @click="e6 = 3" :disabled="!formDatosContacto">
            Continuar
          </v-btn>
          <v-btn text @click="e6 = 1"> Regresar </v-btn>
        </v-form>
      </v-stepper-content>

      <v-stepper-step :complete="e6 > 3" step="3">
        Foto
        <small>Escoge alguna foto del miembro</small>
      </v-stepper-step>

      <v-stepper-content step="3">
        <v-card class="mb-12">
          <v-file-input :rules="reglaImagen" accept="image/png, image/jpeg, image/bmp"
            placeholder="Selecciona una imagen" prepend-icon="mdi-camera" label="Foto" v-model="imagen" type="file"
            @change="onSeleccionarImagen"></v-file-input>
          <div class="d-flex flex-column justify-space-between align-center">
            <img :src="imagenUrl" alt="" aspect-ratio="16/9" width="300" />
          </div>
          <v-card-actions class="justify-center">
            <v-btn color="primary" x-large @click="registrar"> Registrar </v-btn>
            <v-btn text x-large @click="e6 = 2"> Regresar </v-btn>
          </v-card-actions>
        </v-card>
      </v-stepper-content>
    </v-stepper>
  </div>
</template>
<script>
import Utiles from '../../Servicios/Utiles'
export default {
  name: "FormMiembro",
  props: ["miembro"],

  data: () => ({
    formDatosPersonales: false,
    formDatosContacto: false,
    reglasForm: [(value) => !!value || "Campo obligatorio."],
    reglaImagen: [
      (value) =>
        !value || value.size < 5000000 || "La foto debe ser menos de 5 MB",
    ],
    e6: 1,
    imagen: null,
    imagenUrl: null,
    datosPersonales: {
      nombre: "",
      telefono: "",
      direccion: "",
      edad: 18,
    },
    datosContacto: {
      sufreEnfermedad: false,
      tieneSeguro: false,
      enfermedad: "",
      institucion: "",
      afiliacion: "",
      nombreContacto: "",
      telefonoContacto: ""
    },
    reglasNombre: [
      v => !!v || 'El nombre es requerido',
      v => v.length >= 3 || 'Mínimo 3 caracteres'
    ],
    reglasTelefono: [
      v => !!v || 'El teléfono es requerido',
      v => /^[0-9]+$/.test(v) || 'Solo se permiten números',
      v => v.length >= 7 || 'Debe tener al menos 7 dígitos'
    ],
    reglasDireccion: [
      v => !!v || 'El domicilio es requerido'
    ],
    reglasEdad: [
      v => !!v || 'La edad es requerida',
      v => /^[0-9]+$/.test(v) || 'Solo se permiten números',
      v => parseInt(v) > 0 || 'Debe ser mayor a 0'
    ]


  }),

  mounted() {
    this.formDatosPersonales = false;
    this.formDatosContacto = false;

  },

  methods: {

    registrar() {
      let miembro = {
        ...this.datosPersonales,
        ...this.datosContacto,
        imagen: this.imagenUrl,
      };

      this.$emit("registrado", miembro)
      this.formDatosPersonales = false
      this.formDatosContacto = false,
        this.e6 = 1
      this.imagen = null
      this.imagenUrl = null
      this.datosPersonales = {
        nombre: "",
        telefono: "",
        direccion: "",
        edad: 18,
      }
      this.datosContacto = {
        sufreEnfermedad: false,
        tieneSeguro: false,
        enfermedad: "",
        institucion: "",
        afiliacion: "",
        nombreContacto: "",
        telefonoContacto: "",
      }
    },

    crearImagen(imagen) {
      const reader = new FileReader()

      reader.onload = e => {
        this.imagenUrl = e.target.result
      }
      reader.readAsDataURL(imagen)
    },

    onSeleccionarImagen() {
      if (!this.imagen) {
        return
      }
      this.crearImagen(this.imagen);
    }
  },

  watch: {
    miembro: {
      deep: true,
      handler() {
        this.datosPersonales = this.miembro.datosPersonales
        this.datosContacto = this.miembro.datosContacto
        this.imagenUrl = Utiles.generarURL(this.miembro.imagen)

      }
    }
  }

};
</script>
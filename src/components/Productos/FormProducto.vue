<template>
    <v-card>
        <v-card-title>
            <span>{{ titulo }} producto</span>
        </v-card-title>

        <v-card-text>
            <v-form ref="form" lazy-validation>

                <v-text-field v-model="producto.nombre" label="Nombre" required :counter="25" maxlength="25" />
                <v-textarea v-model="producto.descripcion" label="Descripción" required />
                <v-text-field v-model="producto.precio" label="Precio" type="number" required />
                <v-text-field v-model="producto.stock" label="Stock" type="number" required />
                <v-select v-model="producto.categoria" :items="categorias" label="Categoría" required />
                <v-file-input v-model="producto.imagen" label="Imagen del producto" accept="image/*" show-size
                    prepend-icon="mdi-image" @change="onImagenSeleccionada" />
            </v-form>
        </v-card-text>

        <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn text color="grey" @click="$emit('cerrado', false)">Cancelar</v-btn>
            <v-btn color="primary" @click="registrar">Guardar</v-btn>
        </v-card-actions>
    </v-card>
</template>

<script>
export default {
    name: "FormProducto",
    props: {
        titulo: String,
        producto: Object
    },
    data() {
        return {
            categorias: ['Equipamiento y maquinaria', 'Ropa y accesorios', 'Suplementos y nutrición', ' Limpieza e higiene', 'Productos deportivos / energetivos', 'Consumibles', 'Otros productos'],
            imagenBase64: ""
        };
    },
    methods: {
        registrar() {
            const producto = {
                ...this.producto,
                imagen: this.imagenBase64 || this.producto.imagen
            };
            this.$emit('registrar', producto);
        },
        onImagenSeleccionada(file) {
            if (!file) return;
            const reader = new FileReader();
            reader.onload = e => {
                this.imagenBase64 = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    }
};
</script>
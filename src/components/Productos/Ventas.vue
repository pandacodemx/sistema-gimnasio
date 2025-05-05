<template>
    <div class="ventas">
        <h1>Módulo de Ventas</h1>

        <!-- Nueva venta -->
        <v-card class="mb-6">
            <v-card-title>
                <span class="headline">Nueva Venta</span>
            </v-card-title>
            <v-card-text>
                <v-row>
                    <v-col cols="12" md="6">
                        <v-autocomplete v-model="venta.id_miembro" :items="miembros" item-text="nombre" item-value="id"
                            label="Miembro" clearable></v-autocomplete>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-autocomplete v-model="productoSeleccionado" :items="productosDisponibles" item-text="nombre"
                            item-value="id" label="Producto" return-object @change="agregarProducto" clearable>
                            <template v-slot:item="{ item }">
                                <v-list-item-content>
                                    <v-list-item-title>{{ item.nombre }}</v-list-item-title>
                                    <v-list-item-subtitle>
                                        Precio: ${{ item.precio }} | Stock: {{ item.stock }}
                                    </v-list-item-subtitle>
                                </v-list-item-content>
                            </template>
                        </v-autocomplete>
                    </v-col>
                </v-row>

                <!-- Lista de productos agregados -->
                <v-data-table :headers="encabezadoProductos" :items="venta.productos" hide-default-footer
                    class="elevation-1 mt-4">
                    <template v-slot:item.acciones="{ item }">
                        <v-icon small @click="eliminarProducto(item)">
                            mdi-delete
                        </v-icon>
                    </template>
                    <template v-slot:item.cantidad="{ item }">
                        <v-text-field v-model.number="item.cantidad" type="number" min="1" :max="item.stock" dense
                            outlined @input="calcularTotal"></v-text-field>
                    </template>
                </v-data-table>

                <v-divider class="my-4"></v-divider>

                <div class="text-right">
                    <h3>Total: ${{ venta.total.toFixed(2) }}</h3>
                </div>
            </v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn color="primary" @click="registrarVenta" :disabled="!ventaValida">
                    Registrar Venta
                </v-btn>
            </v-card-actions>
        </v-card>

        <!-- Historial de ventas -->
        <v-data-table :headers="encabezadoVentas" :items="ventas" :loading="cargando" class="elevation-1">
            <template v-slot:item.fecha="{ item }">
                {{ formatearFecha(item.fecha) }}
            </template>
            <template v-slot:item.total="{ item }">
                ${{ item.total.toFixed(2) }}
            </template>
            <template v-slot:item.acciones="{ item }">
                <v-btn small color="info" @click="verDetalle(item)">
                    Detalle
                </v-btn>
            </template>
        </v-data-table>

        <!-- Diálogo de detalle -->
        <v-dialog v-model="dialogoDetalle" max-width="600px">
            <v-card>
                <v-card-title>
                    Detalle de Venta #{{ ventaSeleccionada.id }}
                </v-card-title>
                <v-card-text>
                    <p><strong>Miembro:</strong> {{ ventaSeleccionada.nombre_miembro || 'No especificado' }}</p>
                    <p><strong>Fecha:</strong> {{ formatearFecha(ventaSeleccionada.fecha) }}</p>
                    <p><strong>Total:</strong> ${{ ventaSeleccionada.total.toFixed(2) }}</p>

                    <v-data-table :headers="encabezadoDetalle" :items="detalleVenta" hide-default-footer
                        class="mt-4"></v-data-table>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="primary" text @click="dialogoDetalle = false">
                        Cerrar
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script>
import HttpService from '../../Servicios/HttpService';
import Utiles from "../../Servicios/Utiles";

export default {
    name: "Ventas",
    data: () => ({
        cargando: false,
        venta: {
            id_miembro: null,
            productos: [],
            total: 0
        },
        productoSeleccionado: null,
        miembros: [],
        productosDisponibles: [],
        ventas: [],
        detalleVenta: [],
        ventaSeleccionada: {},
        dialogoDetalle: false,
        encabezadoProductos: [
            { text: "Producto", value: "nombre" },
            { text: "Precio unitario", value: "precio" },
            { text: "Cantidad", value: "cantidad" },
            { text: "Subtotal", value: "subtotal" },
            { text: "Acciones", value: "acciones", sortable: false }
        ],
        encabezadoVentas: [
            { text: "ID", value: "id" },
            { text: "Fecha", value: "fecha" },
            { text: "Miembro", value: "nombre_miembro" },
            { text: "Total", value: "total" },
            { text: "Acciones", value: "acciones", sortable: false }
        ],
        encabezadoDetalle: [
            { text: "Producto", value: "nombre_producto" },
            { text: "Precio unitario", value: "precio_unitario" },
            { text: "Cantidad", value: "cantidad" },
            { text: "Subtotal", value: "subtotal" }
        ]
    }),
    computed: {
        ventaValida() {
            return this.venta.productos.length > 0 && this.venta.total > 0;
        }
    },
    mounted() {
        this.obtenerDatosIniciales();
    },
    methods: {
        formatearFecha(fecha) {
            return Utiles.formatearFecha(fecha);
        },
        async obtenerDatosIniciales() {
            this.cargando = true;
            try {
                // Obtener miembros
                const payloadMiembros = { metodo: "get" };
                this.miembros = await HttpService.obtenerConDatos(payloadMiembros, "miembros.php");

                // Obtener productos con stock
                const payloadProductos = { metodo: "get" };
                const productos = await HttpService.obtenerConDatos(payloadProductos, "productos.php");
                this.productosDisponibles = productos.filter(p => p.stock > 0);

                // Obtener historial de ventas
                const payloadVentas = { metodo: "get" };
                this.ventas = await HttpService.obtenerConDatos(payloadVentas, "ventas.php");
            } catch (error) {
                console.error("Error al obtener datos:", error);
            } finally {
                this.cargando = false;
            }
        },
        agregarProducto(producto) {
            if (!producto) return;

            // Verificar si el producto ya está agregado
            const index = this.venta.productos.findIndex(p => p.id === producto.id);

            if (index >= 0) {
                // Si ya existe, aumentar cantidad si hay stock disponible
                if (this.venta.productos[index].cantidad < producto.stock) {
                    this.venta.productos[index].cantidad += 1;
                } else {
                    alert("No hay suficiente stock disponible");
                }
            } else {
                // Si no existe, agregarlo con cantidad 1
                this.venta.productos.push({
                    id: producto.id,
                    nombre: producto.nombre,
                    precio: producto.precio,
                    cantidad: 1,
                    stock: producto.stock,
                    subtotal: producto.precio
                });
            }

            this.calcularTotal();
            this.productoSeleccionado = null;
        },
        eliminarProducto(producto) {
            this.venta.productos = this.venta.productos.filter(p => p.id !== producto.id);
            this.calcularTotal();
        },
        calcularTotal() {
            this.venta.total = this.venta.productos.reduce((total, producto) => {
                producto.subtotal = producto.precio * producto.cantidad;
                return total + producto.subtotal;
            }, 0);
        },
        async registrarVenta() {
            if (!this.ventaValida) return;

            this.cargando = true;
            try {
                const payload = {
                    metodo: "post",
                    venta: this.venta
                };

                const resultado = await HttpService.registrar(payload, "ventas.php");

                if (resultado) {
                    this.$emit("mostrarMensaje", {
                        texto: "Venta registrada correctamente",
                        color: "success"
                    });

                    // Resetear formulario
                    this.venta = {
                        id_miembro: null,
                        productos: [],
                        total: 0
                    };

                    // Actualizar lista de ventas
                    await this.obtenerDatosIniciales();
                }
            } catch (error) {
                console.error("Error al registrar venta:", error);
                this.$emit("mostrarMensaje", {
                    texto: "Error al registrar la venta",
                    color: "error"
                });
            } finally {
                this.cargando = false;
            }
        },
        async verDetalle(venta) {
            this.ventaSeleccionada = venta;

            try {
                const payload = {
                    metodo: "get_detalle",
                    id: venta.id
                };

                this.detalleVenta = await HttpService.obtenerConDatos(payload, "ventas.php");

                // Calcular subtotales para el detalle
                this.detalleVenta = this.detalleVenta.map(item => ({
                    ...item,
                    subtotal: item.precio_unitario * item.cantidad
                }));

                this.dialogoDetalle = true;
            } catch (error) {
                console.error("Error al obtener detalle:", error);
            }
        }
    }
};
</script>

<style>
.ventas {
    padding: 20px;
}

/* Estilos adicionales según tus preferencias */
</style>
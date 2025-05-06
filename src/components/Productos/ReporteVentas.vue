<template>
    <div class="productos">
        <periodo-busqueda @buscar="onBuscar" />

        <cartas-totales v-if="ventas.length > 0" :totales="totalesProductos" :titulo="'Pagos realizados por productos'"
            :icono="'mdi-cash-multiple'" :color="'secondary'" />
        <br>
        <hr>

        <v-card class="mt-3">
            <h1>Pagos totales: <span class="primary--text font-weight-bold display-1"> ${{ totalVentas }}</span></h1>
            <v-card-title>
                Pagos realizados:
                <b v-if="!filtros.fechaInicio"> hoy</b>
                <b v-if="filtros.fechaInicio"> &nbsp; {{ filtros.fechaInicio }} - {{ filtros.fechaFin }}</b>
                <v-spacer></v-spacer>
                <v-text-field v-model="busqueda" append-icon="mdi-magnify" label="Buscar" single-line
                    hide-details></v-text-field>
            </v-card-title>
            <v-btn color="error" @click="generarPDF">
                <v-icon left>mdi-file-pdf-box</v-icon>
                Descargar PDF
            </v-btn>
            <v-btn color="success" @click="generarExcel">
                <v-icon left>mdi-file-excel</v-icon>
                Descargar Excel
            </v-btn>
            <v-data-table :loading="cargando" :headers="encabezadoTabla" :items="ventas" :search="busqueda"
                sort-by="producto" class="elevation-1" :footer-props="{ itemsPerPageText: 'Por página' }">
                <template v-slot:[`item.imagen`]="{ item }">
                    <v-avatar v-if="item.imagen">
                        <img :src="urlImagen(item.imagen)" alt="Foto">
                    </v-avatar>
                </template>

                <template slot="no-data">
                    <v-alert :value="true" color="error" icon="warning">
                        No se han encontrado datos :(
                    </v-alert>
                </template>

                <template v-slot:[`item.producto`]="{ item }">
                    <div>{{ item.producto }}</div>
                </template>
            </v-data-table>

        </v-card>

        <cartas-totales v-if="ventas.length > 0" class="mt-3" :totales="totalesVendedores"
            :titulo="'Pagos realizados por vendedor'" :icono="'mdi-account-cash'" :color="'green darken-3'" />
    </div>
</template>
<script>
import HttpService from '../../Servicios/HttpService'
import Utiles from '../../Servicios/Utiles'
import PeriodoBusqueda from '../Dialogos/PeriodoBusqueda.vue'
import CartasTotales from '../Dialogos/CartasTotales.vue'
import { saveAs } from 'file-saver'
import * as XLSX from 'xlsx'
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable'

export default {
    name: "VentasProductos",
    components: { PeriodoBusqueda, CartasTotales },
    data() {
        return {
            busqueda: "",
            cargando: false,
            ventas: [],
            encabezadoTabla: [
                { text: "Producto", sortable: true, value: "producto" },
                { text: "Fecha", sortable: true, value: "fecha" },
                { text: "Monto pagado", sortable: true, value: "monto" },
                { text: "Vendedor", sortable: true, value: "vendedor" },
            ],
            filtros: {
                fechaInicio: null,
                fechaFin: null
            },
            totalVentas: 0,
            totalesProductos: [],
            totalesVendedores: []
        }
    },
    mounted() {
        this.obtenerVentas()
    },
    methods: {
        generarExcel() {
            const datos = this.ventas.map(venta => ({
                Producto: venta.producto,
                Fecha: venta.fecha,
                'Monto pagado': venta.monto,
                Vendedor: venta.vendedor,
            }));

            const ws = XLSX.utils.json_to_sheet(datos, { origin: 'A3' });
            XLSX.utils.sheet_add_aoa(ws, [["Reporte de Pagos de Productos"], [],], { origin: 'A1' });
            ws['!cols'] = [{ wch: 20 }, { wch: 15 }, { wch: 15 }, { wch: 20 }];
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, 'Pagos');

            const wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
            saveAs(new Blob([wbout], { type: 'application/octet-stream' }), 'reporte_ventas_productos.xlsx');
        },

        generarPDF() {
            const doc = new jsPDF({ orientation: 'portrait', unit: 'pt', format: 'A4' });

            const pageWidth = doc.internal.pageSize.getWidth();
            const title = "Reporte de Pagos de Productos";
            doc.setFontSize(18);
            doc.setFont('helvetica', 'bold');
            const textWidth = doc.getTextWidth(title);
            doc.text(title, (pageWidth - textWidth) / 2, 40);

            const columnas = [
                { header: 'Producto', dataKey: 'producto' },
                { header: 'Fecha', dataKey: 'fecha' },
                { header: 'Monto', dataKey: 'monto' },
                { header: 'Vendedor', dataKey: 'vendedor' },
            ];

            autoTable(doc, {
                startY: 70,
                head: [columnas.map(col => col.header)],
                body: this.ventas.map(item => [
                    item.producto,
                    item.fecha,
                    `$${item.monto}`,
                    item.vendedor
                ]),
                theme: 'striped',
                headStyles: {
                    fillColor: [41, 128, 185],
                    textColor: 255,
                    fontStyle: 'bold',
                },
                styles: {
                    fontSize: 10,
                    cellPadding: 5,
                },
                margin: { top: 70, bottom: 50 },
            });

            doc.save('reporte_ventas_productos.pdf');
        },

        onBuscar(fechas) {
            console.log(fechas);
            this.filtros = {
                fechaInicio: fechas[0],
                fechaFin: fechas[1]
            };
            this.obtenerVentas();
        },

        urlImagen(imagen) {
            return Utiles.generarURL(imagen);
        },

        obtenerVentas() {
            this.cargando = true;
            let payload = {
                metodo: 'obtenerVentas',
                filtros: this.filtros
            };
            HttpService.obtenerConDatos(payload, 'ventas_productos.php')
                .then(respuesta => {
                    this.ventas = respuesta.ventas;
                    this.totalVentas = respuesta.totalVentas;
                    this.totalesProductos = respuesta.totalesProductos;
                    this.totalesVendedores = respuesta.totalesVendedores;
                    this.cargando = false;
                })
                .catch(err => {
                    console.error("Error al obtener las ventas", err);
                    this.cargando = false;
                });
        },
    }
}
</script>

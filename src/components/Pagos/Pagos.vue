<template>
    <div class="miembros">
        <periodo-busqueda @buscar="onBuscar" />

        <cartas-totales v-if="pagos.length > 0" :totales="totalesMembresias" :titulo="'Pagos realizados membresías'"
            :icono="'mdi-cash-multiple'" :color="'secondary'" />
        <br>
        <hr>

        <v-card class="mt-3">
            <v-card-title class="d-flex flex-column align-start pa-6">
                <h2 class="text-h5 font-weight-bold mb-2">💵💰 Pagos totales</h2>
                <span class="display-2 font-weight-black text--primary">${{ totalPagos }}</span>
            </v-card-title>
            <v-card-title class="px-6 d-flex align-center">
                <span class="subtitle-1 font-weight-medium">Pagos realizados:</span>
                <b v-if="!filtros.fechaInicio"> hoy</b>
                <b v-else>&nbsp; {{ filtros.fechaInicio }} - {{ filtros.fechaFin }}</b>

                <v-spacer></v-spacer>
                <v-text-field v-model="busqueda" append-icon="mdi-magnify" label="Buscar" single-line hide-details dense
                    outlined class="ml-4" style="max-width: 300px" />
            </v-card-title>
            <v-card-actions class="pa-4">
                <v-btn color="error" class="ma-2" elevation="2" @click="generarPDF">
                    <v-icon left>mdi-file-pdf-box</v-icon>
                    Descargar PDF
                </v-btn>
                <v-btn color="success" class="ma-2" elevation="2" @click="generarExcel">
                    <v-icon left>mdi-file-excel</v-icon>
                    Descargar Excel
                </v-btn>
            </v-card-actions>
            <v-data-table :loading="cargando" :headers="encabezadoTabla" :items="pagos" :search="busqueda"
                sort-by="nombre" class="elevation-1" :footer-props="{ itemsPerPageText: 'Por página' }">
                <template v-slot:[`item.imagen`]="{ item }">
                    <v-avatar v-if="item.imagen">
                        <img :src="urlImagen(item.imagen)" alt="Foto">
                    </v-avatar>
                </template>
                <template v-slot:[`item.fecha`]="{ item }">
                    {{ fechaFormateada(item.fecha) }}
                </template>


                <template slot="no-data">
                    <v-alert :value="true" color="error" icon="warning">
                        No se han encontrado datos :(
                    </v-alert>
                </template>

                <template v-slot:[`item.membresia`]="{ item }">
                    <div class="medalla" :class="claseMembresia(item.membresia)">
                        <v-icon left small>{{ iconoMembresia(item.membresia) }}</v-icon>
                        {{ item.membresia }}
                    </div>
                </template>
            </v-data-table>

        </v-card>
        <cartas-totales v-if="pagos.length > 0" class="mt-3" :totales="totalesUsuarios"
            :titulo="'Pagos realizados por usuario'" :icono="'mdi-account-cash'" :color="'green darken-3'" />

        <cartas-totales-miembros v-if="pagos.length > 0" class="mt-3" :totales="totalesMiembros"
            :titulo="'Pagos realizados por miembros'" />

        <v-overlay :value="cargando">
            <v-progress-circular indeterminate size="64"></v-progress-circular>
        </v-overlay>

    </div>

</template>
<script>
import HttpService from '../../Servicios/HttpService'
import Utiles from '../../Servicios/Utiles'
import PeriodoBusqueda from '../Dialogos/PeriodoBusqueda.vue'
import CartasTotales from '../Dialogos/CartasTotales.vue'
import CartasTotalesMiembros from '../Dialogos/CartasTotalesMiembros.vue'
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable'
import * as XLSX from 'xlsx'
import { saveAs } from 'file-saver'
import { formatearFechaHora } from '@/utils/fechas';

export default {
    name: "Pagos",
    components: { PeriodoBusqueda, CartasTotales, CartasTotalesMiembros },
    data: () => ({
        busqueda: "",
        cargando: false,
        pagos: [],
        encabezadoTabla: [
            { text: "Fotografia", sortable: true, value: "imagen" },
            { text: "Miembro", sortable: true, value: "nombre" },
            { text: "Matrícula", sortable: true, value: "matricula" },
            { text: "Membresía", sortable: true, value: "membresia" },
            {
                text: "Fecha", sortable: true, value: "fecha",
                formatter: (value) => this.fechaFormateada(value)
            },
            { text: "Monto pagado", sortable: true, value: "monto" },
            { text: "Cobró", sortable: true, value: "usuario" },
        ],
        filtros: {
            fechaInicio: null,
            fechaFin: null
        },
        totalPagos: 0,
        totalesMembresias: [],
        totalesUsuarios: [],
        totalesMiembros: []
    }),

    mounted() {
        this.obtenerPagos()
    },

    methods: {
        fechaFormateada(fecha) {
            return formatearFechaHora(fecha);
        },
        generarExcel() {
            const datos = this.pagos.map(pago => ({
                Miembro: pago.nombre,
                Matrícula: pago.matricula,
                Membresía: pago.membresia,
                Fecha: pago.fecha,
                'Monto pagado': pago.monto,
                Usuario: pago.usuario,
            }));

            const ws = XLSX.utils.json_to_sheet(datos, { origin: 'A3' });
            XLSX.utils.sheet_add_aoa(ws, [
                ["Reporte de Pagos"],
                [],
            ], { origin: 'A1' });
            ws['!cols'] = [
                { wch: 20 }, // Miembro
                { wch: 15 }, // Matrícula
                { wch: 20 }, // Membresía
                { wch: 15 }, // Fecha
                { wch: 15 }, // Monto
                { wch: 20 }, // Usuario
            ];
            ws['!autofilter'] = {
                ref: "A3:F3"
            };

            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, 'Pagos');

            const wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
            saveAs(new Blob([wbout], { type: 'application/octet-stream' }), 'reporte_pagos.xlsx');
        },
        generarPDF() {
            const doc = new jsPDF({ orientation: 'portrait', unit: 'pt', format: 'A4' });

            const pageWidth = doc.internal.pageSize.getWidth();

            // Dibujar el título centrado
            const title = "Reporte de Pagos";
            doc.setFontSize(18);
            doc.setFont('helvetica', 'bold');
            const textWidth = doc.getTextWidth(title);
            doc.text(title, (pageWidth - textWidth) / 2, 40);

            const columnas = [
                { header: 'Miembro', dataKey: 'nombre' },
                { header: 'Matrícula', dataKey: 'matricula' },
                { header: 'Membresía', dataKey: 'membresia' },
                { header: 'Fecha', dataKey: 'fecha' },
                { header: 'Monto', dataKey: 'monto' },
                { header: 'Cobró', dataKey: 'usuario' },
            ];

            autoTable(doc, {
                startY: 70,
                head: [columnas.map(col => col.header)],
                body: this.pagos.map(item => [
                    item.nombre,
                    item.matricula,
                    item.membresia,
                    item.fecha,
                    `$${item.monto}`,
                    item.usuario
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
                didDrawPage: function (data) {
                    // Pie de página
                    const pageCount = doc.internal.getNumberOfPages();
                    const pageSize = doc.internal.pageSize;
                    const pageHeight = pageSize.height ? pageSize.height : pageSize.getHeight();

                    doc.setFontSize(10);
                    doc.setTextColor(150);
                    doc.text(`Página ${doc.internal.getCurrentPageInfo().pageNumber} de ${pageCount}`, pageWidth / 2, pageHeight - 20, { align: 'center' });
                },
            });

            doc.save('reporte_pagos.pdf');
        },
        onBuscar(fechas) {
            console.log(fechas)
            this.filtros = {
                fechaInicio: fechas[0],
                fechaFin: fechas[1]
            }

            this.obtenerPagos()
        },

        urlImagen(imagen) {
            return Utiles.generarURL(imagen)
        },

        obtenerPagos() {
            this.cargando = true
            let payload = {
                metodo: 'obtener',
                filtros: this.filtros
            }
            HttpService.obtenerConDatos(payload, 'pagos.php')
                .then(respuesta => {
                    this.pagos = respuesta.pagos
                    this.totalPagos = respuesta.totalPagos
                    this.totalesMembresias = respuesta.totalesMembresias
                    this.totalesUsuarios = respuesta.totalesUsuario
                    this.totalesMiembros = respuesta.totalesMiembros
                    console.log(respuesta)
                    this.cargando = false
                })

        },
        claseMembresia(nombre) {
            const tipo = (nombre && nombre.toLowerCase()) || ''
            if (tipo.includes('semanal')) return 'medalla-oro'
            if (tipo.includes('mensual hombre')) return 'medalla-plata'
            if (tipo.includes('mensual mujer')) return 'medalla-mujer'
            if (tipo.includes('mensual pareja / estudiante')) return 'medalla-bronce'
            if (tipo.includes('semestral')) return 'medalla-premium'
            return 'medalla-default'
        },

        iconoMembresia(nombre) {
            const tipo = (nombre && nombre.toLowerCase()) || ''
            if (tipo.includes('semanal')) return 'mdi-trophy'
            if (tipo.includes('mensual hombre')) return 'mdi-face-man'
            if (tipo.includes('mensual mujer')) return 'mdi-face-woman'
            if (tipo.includes('mensual pareja / estudiante')) return 'mdi-human-male-female'
            if (tipo.includes('semestral')) return 'mdi-calendar-range'
            return 'mdi-certificate'
        }

    }
}
</script>
<style>
.miembros {
    padding: 30px;
    background: linear-gradient(145deg, #1e1e1e, #252525);
    border-radius: 16px;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
}

.medalla {
    display: inline-flex;
    align-items: center;
    padding: 6px 12px;
    border-radius: 999px;
    font-weight: bold;
    font-size: 14px;
    color: #fff;
    text-transform: capitalize;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

.medalla-oro {
    background: linear-gradient(145deg, #0f4933, #21a572);
}

.medalla-plata {
    background: linear-gradient(145deg, #016e8f, #03bff8);
}

.medalla-bronce {
    background: linear-gradient(145deg, #cd3232, #b84333);
}

.medalla-mujer {
    background: linear-gradient(145deg, #7c1a43, #f35a9a);
}

.medalla-premium {
    background: linear-gradient(145deg, #6d1a7c, #b83bee);
}

.medalla-default {
    background: linear-gradient(145deg, #546E7A, #6c8692);
}
</style>
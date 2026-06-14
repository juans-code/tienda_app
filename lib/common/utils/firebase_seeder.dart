// common/utils/firebase_seeder.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Función principal para poblar el Bazar con un catálogo completo de 4-5 productos por categoría
  static Future<void> seedBazarDatabase() async {
    print('🚀 Iniciando la carga del catálogo expandido del Bazar (Snake_Case y URLs Optimizadas)...');

    try {
      // 1. Cargar Categorías
      final List<Map<String, dynamic>> categories = [
        { "id": "cat_hogar_deco", "name": "Hogar y Decoración", "image_url": "https://images.unsplash.com/photo-1618220179428-22790b461013?w=600&q=80" },
        { "id": "cat_cocina_mesa", "name": "Cocina y Mesa", "image_url": "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600&q=80" },
        { "id": "cat_bienestar_aromas", "name": "Bienestar y Aromas", "image_url": "https://images.unsplash.com/photo-1603006905003-be475563bc59?w=600&q=80" },
        { "id": "cat_papeleria_diseno", "name": "Papelería y Diseño", "image_url": "https://images.unsplash.com/photo-1531346878377-a5be20888e57?w=600&q=80" },
        { "id": "cat_accesorios_estilo", "name": "Accesorios y Estilo", "image_url": "https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&q=80" },
        { "id": "cat_bazar_textil", "name": "Textil Hogar", "image_url": "https://images.unsplash.com/photo-1600121848594-d8644e57abab?w=600&q=80" }
      ];

      print('📁 Sincronizando categorías...');
      for (var category in categories) {
        final String catId = category['id'];
        await _firestore.collection('categories').doc(catId).set({
          'name': category['name'],
          'image_url': category['image_url'],
        });
      }

      // 2. Cargar Productos Expandidos (4-5 por categoría)
      final List<Map<String, dynamic>> products = [
        // === HOGAR Y DECORACIÓN ===
        {
          "id": "prod_espejo_sol",
          "category_id": "cat_hogar_deco",
          "name": "Espejo Sol Dorado Artesanal",
          "description": "Espejo de pared con marco de metal forjado en forma de rayos de sol. Ideal para darle calidez al recibidor.",
          "price": 149.90, "stock": 8, "rating": 4.8, "review_count": 14, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1618220179428-22790b461013?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_florero_ceramica",
          "category_id": "cat_hogar_deco",
          "name": "Florero de Cerámica Minimalista",
          "description": "Florero texturizado en tono beige arena. Su diseño orgánico resalta tanto con flores secas como naturales.",
          "price": 54.00, "stock": 12, "rating": 4.6, "review_count": 8, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1578500494198-246f612d3b3d?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_cuadro_botanico",
          "category_id": "cat_hogar_deco",
          "name": "Set de Cuadros Botánicos (x3)",
          "description": "Láminas ilustradas de alta calidad con marcos de madera clara. Perfectos para armar una galería en tu sala.",
          "price": 110.00, "stock": 5, "rating": 4.9, "review_count": 21, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_cesta_organización",
          "category_id": "cat_hogar_deco",
          "name": "Cesta de Almacenamiento de Algas",
          "description": "Canasta tejida a mano con asas. Úsala como revistero, para guardar mantas o como porta macetas chic.",
          "price": 65.00, "stock": 18, "rating": 4.7, "review_count": 33, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1531835551805-16d864c8d311?w=600&q=80", "created_at": Timestamp.now()
        },

        // === COCINA Y MESA ===
        {
          "id": "prod_tazas_ceramica",
          "category_id": "cat_cocina_mesa",
          "name": "Set de 4 Tazas Rústicas",
          "description": "Tazas hechas a mano con acabado esmaltado mate. Aptas para microondas y lavavajillas. Cada pieza es única.",
          "price": 79.00, "stock": 15, "rating": 4.9, "review_count": 22, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_tabla_quesos",
          "category_id": "cat_cocina_mesa",
          "name": "Tabla para Quesos de Madera de Acacia",
          "description": "Tabla de corte y presentación con vetas naturales hermosas y borde orgánico. Incluye colgador de cuero.",
          "price": 95.00, "stock": 10, "rating": 4.8, "review_count": 17, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1541532713592-79a0317b6b77?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_tetera_vidrio",
          "category_id": "cat_cocina_mesa",
          "name": "Tetera de Vidrio con Infusor",
          "description": "Tetera de borosilicato resistente al calor con filtro de acero inoxidable extraíble. Capacidad de 800ml.",
          "price": 68.90, "stock": 14, "rating": 4.5, "review_count": 29, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_platos_peltre",
          "category_id": "cat_cocina_mesa",
          "name": "Set de Platos Llanos de Cerámica Goteada",
          "description": "Juego de 4 platos con diseño artesanal moteado en los bordes. Aportan un estilo campestre y elegante a tu mesa.",
          "price": 135.00, "stock": 6, "rating": 4.7, "review_count": 11, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1535990379313-5cd271a2da2d?w=600&q=80", "created_at": Timestamp.now()
        },

        // === BIENESTAR Y AROMAS ===
        {
          "id": "prod_vela_soja",
          "category_id": "cat_bienestar_aromas",
          "name": "Vela de Soja - Vainilla & Lavanda",
          "description": "Vela aromática ecológica con pabilo de madera que cruje al encenderse. Duración aproximada de 40 horas.",
          "price": 35.50, "stock": 30, "rating": 4.7, "review_count": 45, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1603006905003-be475563bc59?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_difusor_sticks",
          "category_id": "cat_bienestar_aromas",
          "name": "Difusor de Ambiente - Menta & Eucalipto",
          "description": "Frasco de vidrio ámbar con varillas de bambú que distribuyen el aroma de forma continua y sutil por semanas.",
          "price": 42.00, "stock": 25, "rating": 4.6, "review_count": 19, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_aceites_esenciales",
          "category_id": "cat_bienestar_aromas",
          "name": "Kit de 3 Aceites Esenciales Puros",
          "description": "Incluye extracto concentrado de Lavanda, Limón y Árbol de Té. Ideales para humidificadores o masajes de relajación.",
          "price": 59.90, "stock": 40, "rating": 4.9, "review_count": 52, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_sales_bano",
          "category_id": "cat_bienestar_aromas",
          "name": "Sales de Baño Exfoliantes con Rosas",
          "description": "Sal de Epsom mezclada con pétalos secos y aceites hidratantes. Perfectas para un baño relajante y renovador.",
          "price": 28.00, "stock": 15, "rating": 4.4, "review_count": 13, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=600&q=80", "created_at": Timestamp.now()
        },

        // === PAPELERÍA Y DISEÑO ===
        {
          "id": "prod_agenda_bazar",
          "category_id": "cat_papeleria_diseno",
          "name": "Planificador Semanal Perpetuo",
          "description": "Planificador sin fechas para que lo organices a tu ritmo. Tapa dura con detalles en foil dorado y hojas de 90g.",
          "price": 45.00, "stock": 20, "rating": 4.6, "review_count": 9, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1531346878377-a5be20888e57?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_cuaderno_cuero",
          "category_id": "cat_papeleria_diseno",
          "name": "Bitácora de Cuero Vintage",
          "description": "Libreta con cubiertas de cuero genuino y hojas cosidas a mano de papel kraft texturizado. Ideal para bocetos o diarios.",
          "price": 85.00, "stock": 7, "rating": 5.0, "review_count": 16, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_set_boligrafos",
          "category_id": "cat_papeleria_diseno",
          "name": "Set de Bolígrafos de Gel Pastel (x6)",
          "description": "Lapiceros de tinta fina con cuerpo ergonómico mate. Colores suaves ideales para lettering, bullet journal o apuntes.",
          "price": 24.90, "stock": 50, "rating": 4.8, "review_count": 31, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_washi_tapes",
          "category_id": "cat_papeleria_diseno",
          "name": "Colección de Cintas Washi Botánicas",
          "description": "Caja con 8 rollos de cintas adhesivas de papel arroz japonés decoradas con patrones naturales y de acuarela.",
          "price": 19.90, "stock": 35, "rating": 4.7, "review_count": 24, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1513151233558-d860c5398176?w=600&q=80", "created_at": Timestamp.now()
        },

        // === ACCESORIOS Y ESTILO ===
        {
          "id": "prod_bolso_yute",
          "category_id": "cat_accesorios_estilo",
          "name": "Bolso Tote de Yute y Cuero Vegano",
          "description": "Bolso espacioso y ecológico, ideal para tus compras del día a día o una tarde de paseo. Forrado por dentro.",
          "price": 89.90, "stock": 12, "rating": 4.5, "review_count": 18, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_sombrero_paja",
          "category_id": "cat_accesorios_estilo",
          "name": "Sombrero Playero de Paja Fina",
          "description": "Sombrero de ala ancha con listón negro regulable. Te brinda una excelente protección solar con un estilo atemporal.",
          "price": 62.00, "stock": 9, "rating": 4.3, "review_count": 7, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1533827432537-70133748f5c8?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_neceser_lino",
          "category_id": "cat_accesorios_estilo",
          "name": "Neceser Organizador de Lino",
          "description": "Cosmetiquera compacta con forro impermeable interior y cierre dorado. Perfecta para llevar tus esenciales en el bolso.",
          "price": 35.00, "stock": 22, "rating": 4.6, "review_count": 12, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_joyero_viaje",
          "category_id": "cat_accesorios_estilo",
          "name": "Mini Joyero de Viaje de Terciopelo",
          "description": "Estuche rígido con compartimentos internos acolchados para anillos, aretes y collares. Evita enredos con elegancia.",
          "price": 49.00, "stock": 16, "rating": 4.8, "review_count": 40, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80", "created_at": Timestamp.now()
        },

        // === TEXTIL HOGAR ===
        {
          "id": "prod_manta_algodon",
          "category_id": "cat_bazar_textil",
          "name": "Manta de Algodón con Flecos",
          "description": "Manta ligera y súper suave para el sillón o pie de cama. Tejido transpirable en un tono crudo que combina con todo.",
          "price": 120.00, "stock": 5, "rating": 5.0, "review_count": 7, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1600121848594-d8644e57abab?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_cojin_lino",
          "category_id": "cat_bazar_textil",
          "name": "Funda de Cojín en Lino Moteado",
          "description": "Funda decorativa de lino con textura rústica y cierre oculto. Combina perfectamente con ambientes nórdicos o rústicos.",
          "price": 39.90, "stock": 25, "rating": 4.7, "review_count": 14, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_mantel_antimanchas",
          "category_id": "cat_bazar_textil",
          "name": "Mantel de Mesa de Lino Antimanchas",
          "description": "Mantel rectangular para mesa de 6 sillas. Cuenta con un tratamiento repelente a líquidos que facilita la limpieza diaria.",
          "price": 98.00, "stock": 8, "rating": 4.5, "review_count": 20, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1603006905393-c357f87df60a?w=600&q=80", "created_at": Timestamp.now()
        },
        {
          "id": "prod_alfombra_yute",
          "category_id": "cat_bazar_textil",
          "name": "Alfombra Redonda de Yute Trenzado",
          "description": "Alfombra tejida artesanalmente de 120 cm de diámetro. Ideal para colocar debajo de una butaca o en la entrada.",
          "price": 165.00, "stock": 4, "rating": 4.8, "review_count": 19, "is_available": true,
          "image_url": "https://images.unsplash.com/photo-1600121848896-db36f50b4b7c?w=600&q=80", "created_at": Timestamp.now()
        }
      ];

      print('📦 Sincronizando productos expandidos...');
      for (var product in products) {
        final String prodId = product['id'];
        final Map<String, dynamic> productData = Map.from(product)..remove('id');
        
        await _firestore.collection('products').doc(prodId).set(productData);
      }
      
      print('🎉 ¡Todo listo! Tu Bazar ahora cuenta con un catálogo robusto de 24 productos distribuidos equitativamente.');
    } catch (e) {
      print('❌ Error crítico en el Seeder Expandido: $e');
    }
  }
}
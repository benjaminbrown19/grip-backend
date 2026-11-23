-- Solo ejecutar DESPUES de arrancar el backend por primera vez (crea tabla productos).
USE grip_sneaker_store;
INSERT INTO productos (codigo,nombre,descripcion,precio,stock,stock_critico,categoria,descuento,imagen) VALUES
('SNK-001','GRIP Street 90','Zapatilla urbana de cana baja, silueta retro y entresuela acolchada.',54990,18,5,'urbano',0,'/assets/img/producto-snk-001.jpg'),
('SNK-002','GRIP Runner X1','Zapatilla de running liviana, malla transpirable.',64990,12,4,'running',15,'/assets/img/producto-snk-002.jpg'),
('SNK-003','GRIP Court Pro','Zapatilla de basketball de cana alta, soporte reforzado.',79990,3,5,'basketball',0,'/assets/img/producto-snk-003.jpg'),
('SNK-004','GRIP Slide Skate','Zapatilla de skate con puntera reforzada.',49990,25,6,'skate',0,'/assets/img/producto-snk-004.jpg'),
('SNK-005','GRIP Street Low','Version de cana baja de la linea urbana.',47990,20,5,'urbano',10,'/assets/img/producto-snk-005.jpg'),
('SNK-006','GRIP Velocity','Zapatilla de running de competencia.',69990,9,4,'running',0,'/assets/img/producto-snk-006.jpg'),
('SNK-007','GRIP Baseline','Zapatilla de basketball con amortiguacion.',84990,14,5,'basketball',0,'/assets/img/producto-snk-007.jpg'),
('SNK-008','GRIP Grind Deck','Zapatilla de skate de perfil bajo.',52990,16,5,'skate',20,'/assets/img/producto-snk-008.jpg')
ON DUPLICATE KEY UPDATE codigo=VALUES(codigo);

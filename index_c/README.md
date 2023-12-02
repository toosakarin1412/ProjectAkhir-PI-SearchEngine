# Hasil Analisis Index C

## File Param
![param.png](img/param.png)
Pada file param berisikan 2 buah parameter
- Banyak dokumen (Nomor 1) Dengan tipe *long int (32bit)*
- Banyak kata unik (Nomor 2) dengan tipe *long int (32bit)*

# Log
- index-db.c<br> 
Tidak dapat membuka file (kesalahan path).<br>
Penambahkan ```strcat(path,"/")``` untuk memperbaiki path. 
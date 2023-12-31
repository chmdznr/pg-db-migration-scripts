#!/usr/bin/env bash

/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/disposisi local/skdv2/disposisi
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/dokumen-pemindahan local/skdv2/dokumen-pemindahan
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/dokumen-penyerahan local/skdv2/dokumen-penyerahan
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/file_ttd local/skdv2/file_ttd
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/history-naskah-mandiri local/skdv2/history-naskah-mandiri
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/history-naskah local/skdv2/history-naskah
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/lampiran-penyelesaian local/skdv2/lampiran-penyelesaian
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/lampiran local/skdv2/lampiran
# /home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/logo-instansi local/skdv2/logo-instansi
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/mandiri local/skdv2/mandiri
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/naskah-keluar local/skdv2/naskah-keluar
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/naskah-mandiri local/skdv2/naskah-mandiri
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/naskah-masuk local/skdv2/naskah-masuk
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/naskah-view local/skdv2/naskah-view
/home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/penyelesaian local/skdv2/persuratan/penyelesaian
# /home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/template_naskah_dinas local/skdv2/template_naskah_dinas
# /home/srikandi/minio-binaries/mc mirror --remove --newer-than 60d skdv2/persuratan/user-profile local/skdv2/user-profile

# /home/srikandi/minio-binaries/mc mirror --remove local/skdv2/logo-instansi local/srikandi-prod/logo-instansi
# /home/srikandi/minio-binaries/mc mirror --remove local/skdv2/user-profile local/srikandi-prod/user-profile
# /home/srikandi/minio-binaries/mc mirror --remove local/skdv2/template_naskah_dinas local/srikandi-prod/template_naskah_dinas
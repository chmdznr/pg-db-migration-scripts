#!/usr/bin/env bash

# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/disposisi  --remove local/skdv2/disposisi
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/dokumen-pemindahan --remove local/skdv2/dokumen-pemindahan
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/dokumen-penyerahan --remove local/skdv2/dokumen-penyerahan
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/file_ttd --remove local/skdv2/file_ttd
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/history-naskah-mandiri --remove local/skdv2/history-naskah-mandiri
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/history-naskah --remove local/skdv2/history-naskah
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/lampiran-penyelesaian --remove local/skdv2/lampiran-penyelesaian
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/lampiran --remove local/skdv2/lampiran
/home/srikandi/minio-binaries/mc mirror skdv2/persuratan/logo-instansi --remove --newer-than 60d local/skdv2/logo-instansi
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/mandiri --remove local/skdv2/mandiri
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/naskah-keluar --remove local/skdv2/naskah-keluar
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/naskah-mandiri --remove local/skdv2/naskah-mandiri
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/naskah-masuk --remove local/skdv2/naskah-masuk
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/naskah-view --remove local/skdv2/naskah-view
# /home/srikandi/minio-binaries/mc mirror skdv2/persuratan/penyelesaian --remove local/skdv2/persuratan/penyelesaian
/home/srikandi/minio-binaries/mc mirror skdv2/persuratan/template_naskah_dinas --remove --newer-than 60d local/skdv2/template_naskah_dinas
/home/srikandi/minio-binaries/mc mirror skdv2/persuratan/user-profile --remove --newer-than 60d local/skdv2/user-profile

/home/srikandi/minio-binaries/mc mirror local/skdv2/logo-instansi --remove local/srikandi-prod/logo-instansi
/home/srikandi/minio-binaries/mc mirror local/skdv2/user-profile --remove local/srikandi-prod/user-profile
/home/srikandi/minio-binaries/mc mirror local/skdv2/template_naskah_dinas --remove local/srikandi-prod/template_naskah_dinas
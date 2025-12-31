#!/bin/zsh

# source_0.1
folders_01=(
	device_m_215
	device_m_688
	device_m_735
	device_m_870
)
for name in $folders_01; do
	mkdir -p "./source_0.1/$name"
	echo "# $name" >"./source_0.1/$name/README.md"
done

# source_0.2
folders_02=(
	device_m_215
	device_m_688
	device_m_735
	device_m_870
	device_cpm
)
for name in $folders_02; do
	mkdir -p "./source_0.2/$name"
	echo "# $name" >"./source_0.2/$name/README.md"
done

# source_0.4
folders_04=(
	device_m_215
	device_m_688
	device_m_735
	device_m_870
	device_g_360
	device_g_560
	device_g_560_old
	device_g_885
	device_g_915
	device_cpm
	device_adina
	device_flora
	device_flora_old
	device_metis
)
for name in $folders_04; do
	mkdir -p "./source_0.4/$name"
	echo "# $name" >"./source_0.4/$name/README.md"
done

# source_0.5
folders_05=(
	device_m_215
	device_m_688
	device_m_735
	device_m_870
	device_g_350
	device_g_360
	device_g_560_old
	device_g_760
	device_g_885
	device_g_915
	device_adina
	device_cpm
	device_cpm_android
)
for name in $folders_05; do
	mkdir -p "./source_0.5/$name"
	echo "# $name" >"./source_0.5/$name/README.md"
done

# source_0.6
folders_06=(
	device_m_215
	device_m_688
	device_m_735
	device_m_870
	device_g_350
	device_g_360
	device_g_560_old
	device_g_760
	device_g_885
	device_g_915
	device_adina
	device_cpm
	device_cpm_android
	device_endermology
	device_flora
	device_flora_old
	device_metis
)
for name in $folders_06; do
	mkdir -p "./source_0.6/$name"
	echo "# $name" >"./source_0.6/$name/README.md"
done

# source_0.7
folders_07=(
	device_m_870
	device_m_870_MIT
	device_g_760
	device_g_885
	device_ems
	device_dental
	device_gt1
	device_innolase14
	device_vl8
)
for name in $folders_07; do
	mkdir -p "./source_0.7/$name"
	echo "# $name" >"./source_0.7/$name/README.md"
done

# source_0.8
folders_08=(
	device_g_760
	device_ems
	device_cryo
)
for name in $folders_08; do
	mkdir -p "./source_0.8/$name"
	echo "# $name" >"./source_0.8/$name/README.md"
done

# source_0.9
folders_09=(
	device_ems
)
for name in $folders_09; do
	mkdir -p "./source_0.9/$name"
	echo "# $name" >"./source_0.9/$name/README.md"
done

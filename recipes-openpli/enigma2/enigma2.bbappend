FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

inherit upx_compress

SRC_URI_append += " \
	${@bb.utils.contains("TARGET_ARCH", "sh4", "", "git://github.com/PLi-metas/extra_rc_models.git;protocol=git;destsuffix=extra_rc_models;name=extrarcmodels", d)} \
        "

SRCREV_extrarcmodels_pn-${PN} = "${AUTOREV}"
SRCREV_FORMAT = "enigma2_extrarcmodels"

do_configure_prepend() {
	if [ ! "${TARGET_ARCH}" == "sh4" ]
	then
		# Restore the files first in case we run configure twice between checking out the source
		git --git-dir="${S}/.git" --work-tree="${S}" checkout "${S}/data/rc_models/Makefile.am"
		git --git-dir="${S}/.git" --work-tree="${S}" checkout "${S}/data/rc_models/rc_models.cfg"
		git --git-dir="${WORKDIR}/extra_rc_models/.git" --work-tree="${WORKDIR}/extra_rc_models" pull
		for i in $(find "${WORKDIR}/extra_rc_models" -maxdepth 1 -type f -name "*.xml" -o -name "*.png")
		do
			file="$(echo "${i}" | sed 's:.*/::')"
			sed -i '${s/$/'" $file"'/}' "${S}/data/rc_models/Makefile.am"
			cp -f "${i}" "${S}/data/rc_models/"
		done
		cat "${WORKDIR}/extra_rc_models/rc_models.cfg" >> "${S}/data/rc_models/rc_models.cfg"
	fi
}

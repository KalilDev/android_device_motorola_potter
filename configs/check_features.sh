#!/sbin/sh

sku=`getprop ro.boot.hardware.sku`
device=`getprop ro.boot.device`

cameralibs="/system/vendor/lib/hw/camera.msm8953.so
/system/vendor/lib/libmmcamera2_cpp_module.so
/system/vendor/lib/libmmcamera2_q3a_core.so
/system/vendor/lib/libmmcamera2_sensor_modules.so
/system/vendor/lib/libmmcamera2_stats_modues.so
/system/vendor/lib/libmmcamera_imglib.so
/system/vendor/lib/libmmcamera_vstab_module.so
/system/vendor/lib/libmmjpeg_interface.so
/system/vendor/lib/libmotocalibration.so"

sedcam() {
sed -i 's/po5695/ce5695/g' "$1"
sed -i 's/pot362/ced258/g' "$1"
}

if [ "$sku" = "XT1687" ]; then
    # XT1687 doesn't have NFC chip
    rm /system/vendor/etc/permissions/android.hardware.nfc.xml
    rm /system/vendor/etc/permissions/android.hardware.nfc.hce.xml
    rm /system/vendor/etc/permissions/com.android.nfc_extras.xml
    rm -r /system/app/NfcNci
else
    # Only XT1687 variant got a compass
    rm /system/vendor/etc/permissions/android.hardware.sensor.compass.xml
fi

if ! [ "$sku" = "XT1683" ]; then
    # Others variants doesn't have DTV support
    rm /system/vendor/etc/permissions/com.motorola.hardware.dtv.xml
    rm /system/vendor/etc/permissions/mot_dtv_permissions.xml
    rm /system/vendor/lib/libdtvtuner.so
    rm /system/vendor/lib64/libdtvtuner.so
    rm /system/vendor/lib/libdtvhal.so
    rm /system/vendor/lib64/libdtvhal.so
    rm -r /system/vendor/app/DTVPlayer
    rm -r /system/vendor/app/DTVService
fi

if [ "$device" = "cedric" ]; then
	while IFS= read -r file ;do
		sedcam "$file"
	done <<< "$cameralibs"
	sed -i 's/msm8953_mot_potter_camera/msm8937_mot_cedric_camera/' /system/vendor/lib/libmmcamera2_sensor_modules.so
fi
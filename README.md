# Petnet

¡Bienvenido a Petnet! Esta es una aplicación de Flutter diseñada para la detección de enfermedades en perros.

## Clonar el Proyecto

Para clonar este proyecto, ejecuta el siguiente comando en tu terminal:

```bash
git clone https://github.com/{tu usuario}/pet_net_app.git
```

## Instalar Dependencias

Una vez que hayas clonado el repositorio, navega al directorio del proyecto e instala las dependencias necesarias utilizando el siguiente comando:

```bash
cd petnet
flutter pub get
```

## Construir el APK

Para construir el APK de la aplicación, puedes usar el siguiente comando:

```bash
flutter build apk --release
```
El archivo APK generado se encontrará en el directorio build/app/outputs/flutter-apk/app-release.apk.

## Generar el Bundle para Google Play

Si deseas generar el Android App Bundle (AAB) para subir la aplicación a Google Play, utiliza el siguiente comando:

```bash
flutter build appbundle --release
```
El archivo AAB generado se encontrará en el directorio build/app/outputs/bundle/release/app-release.aab.

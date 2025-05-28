icons:
		dart run flutter_launcher_icons:main && dart run icons_launcher:create

splash:
		dart run flutter_native_splash:create

gen:
		dart run build_runner build --delete-conflicting-outputs

fmt:
		dart format lib test

localize:
		flutter gen-l10n

get:
		flutter pub get

clean:
		flutter pub clean

apk:
		flutter build apk

sort:
		dart run import_sorter:main

aab:
		flutter build appbundle

run:
		flutter run --release

run-dev:
		flutter run --release

build: 	# Run the app on a new computer with Flutter 2.3 installed
		flutter pub get && make gen && make run
        
for dir in ./*; do
    cd "$(basename "$dir")"
    for file in ./*.ebuild; do
		echo "$(basename "$file")"
		sed -i 's/KEYWORDS=""/KEYWORDS="arm arm64"/g' "$(basename "$file")"
		ebuild "$(basename "$file")" manifest
	done
	cd ..
done

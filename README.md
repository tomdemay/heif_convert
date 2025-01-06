# How to convert HEIC files

The image created by this docker file simply exposes the example CLI's created by the [libheif API](https://github.com/strukturag/libheif) that support iOS 18 to encode, decode, get metadata and create thumbnails for HEIC image files.

Requires [Docker Engine](https://docs.docker.com/engine/install/) installed. 

---

## Convert from
```bash
docker run --rm -v $(pwd):/wrkspc -w /wrkspc demaytom/heif-convert heif-dec <input-HEIC> [output-image]
```
or
```bash
docker run --rm -v $(pwd):/wrkspc -w /wrkspc demaytom/heif-convert heif-convert <input-HEIC> [output-image]
```
### Usage
```bash
$ docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) heif-convert:1.18 heif-dec --help
 heif-dec  libheif version: 1.18.0
---------------------------------------
Usage: heif-dec [options]  <input-image> [output-image]

The program determines the output file format from the output filename suffix.
These suffixes are recognized: jpg, jpeg, png, y4m. If no output filename is specified, 'jpg' is used.

Options:
  -h, --help                     show help
  -v, --version                  show version
  -q, --quality                  quality (for JPEG output)
  -o, --output FILENAME          write output to FILENAME (optional)
  -d, --decoder ID               use a specific decoder (see --list-decoders)
      --with-aux                 also write auxiliary images (e.g. depth images)
      --with-xmp                 write XMP metadata to file (output filename with .xmp suffix)
      --with-exif                write EXIF metadata to file (output filename with .exif suffix)
      --skip-exif-offset         skip EXIF metadata offset bytes
      --no-colons                replace ':' characters in auxiliary image filenames with '_'
      --list-decoders            list all available decoders (built-in and plugins)
      --quiet                    do not output status messages to console
  -C, --chroma-upsampling ALGO   Force chroma upsampling algorithm (nn = nearest-neighbor / bilinear)
      --png-compression-level #  Set to integer between 0 (fastest) and 9 (best). Use -1 for default.
```
---

## Convert to
```bash
docker run --rm -v $(pwd):/wrkspc -w /wrkspc demaytom/heif-convert heif-enc <input-jpeg>
```
### Usage
```bash
$ docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) heif-convert:1.18 heif-enc --help
 heif-enc  libheif version: 1.18.0
----------------------------------------
Usage: heif-enc [options] image.jpeg ...

When specifying multiple source images, they will all be saved into the same HEIF/AVIF file.

When using the x265 encoder, you may pass it any of its parameters by
prefixing the parameter name with 'x265:'. Hence, to set the 'ctu' parameter,
you will have to set 'x265:ctu' in libheif (e.g.: -p x265:ctu=64).
Note that there is no checking for valid parameters when using the prefix.

Options:
  -h, --help        show help
  -v, --version     show version
  -q, --quality     set output quality (0-100) for lossy compression
  -L, --lossless    generate lossless output (-q has no effect). Image will be encoded as RGB (matrix_coefficients=0).
  -t, --thumb #     generate thumbnail with maximum size # (default: off)
      --no-alpha    do not save alpha channel
      --no-thumb-alpha  do not save alpha channel in thumbnail image
  -o, --output          output filename (optional)
      --verbose         enable logging output (more will increase logging level)
  -P, --params          show all encoder parameters and exit, input file not required or used.
  -b, --bit-depth #     bit-depth of generated HEIF/AVIF file when using 16-bit PNG input (default: 10 bit)
  -p                    set encoder parameter (NAME=VALUE)
  -A, --avif            encode as AVIF (not needed if output filename with .avif suffix is provided)
      --vvc             encode as VVC (experimental)
      --jpeg            encode as JPEG
      --jpeg2000        encode as JPEG 2000 (experimental)
      --htj2k           encode as High Throughput JPEG 2000 (experimental)
      --list-encoders         list all available encoders for all compression formats
  -e, --encoder ID            select encoder to use (the IDs can be listed with --list-encoders)
      --plugin-directory DIR  load all codec plugins in the directory
  -E, --even-size   [deprecated] crop images to even width and height (odd sizes are not decoded correctly by some software)
  --matrix_coefficients     nclx profile: color conversion matrix coefficients, default=6 (see h.273)
  --colour_primaries        nclx profile: color primaries (see h.273)
  --transfer_characteristic nclx profile: transfer characteristics (see h.273)
  --full_range_flag         nclx profile: full range flag, default: 1
  --enable-two-colr-boxes   will write both an ICC and an nclx color profile if both are present
  --premultiplied-alpha     input image has premultiplied alpha
  -C,--chroma-downsampling ALGO   force chroma downsampling algorithm (nn = nearest-neighbor / average / sharp-yuv)
                                  (sharp-yuv makes edges look sharper when using YUV420 with bilinear chroma upsampling)
  --benchmark               measure encoding time, PSNR, and output file size
  --pitm-description TEXT   (experimental) set user description for primary image
```
---

## Create thumbnail
```bash
docker run --rm -v $(pwd):/wrkspc -w /wrkspc demaytom/heif-convert heif-thumbnailer [-s size] <input-image> <output-thumbnail>
```
### Usage
```bash
$ docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) heif-convert:1.18 heif-thumbnailer --help
heif-thumbnailer: invalid option -- '-'
usage: heif-thumbnailer [-s size] [-p] <filename> <output>
 -p   Render thumbnail from primary image, even if thumbnail is stored in image.
 ```
---

## Get meta-data
```bash
docker run --rm -v $(pwd):/wrkspc -w /wrkspc demaytom/heif-convert heif-info <image>
```
### Usage
```bash
$ docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) heif-convert:1.18 heif-info --help
 heif-info  libheif version: 1.18.0
------------------------------------
usage: heif-info [options] image.heic

options:
  -d, --dump-boxes     show a low-level dump of all MP4 file boxes
  -h, --help           show help
  -v, --version        show version
```



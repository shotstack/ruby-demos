# Shotstack Ruby Examples

### Video examples

- **text.rb** - Create a HELLO WORLD video title against black background with a zoom in motion effect and soundtrack.

- **images.rb** - Takes an array of image URLs and creates a video with a soundtrack and simple zoom in effect.

- **titles.rb** - Create a video to demo titles using the available preset font styles, a soundtrack, zoom in motion
    effect and wipe right transition.

- **trim.rb** -
    Trim the start and end of a video clip to output a shortened video.

- **filters.rb** - Applies filters to a video clip, including a title with the name of the filter and a soundtrack.

- **captions.rb** - Parse an SRT transcript file and apply the captions to a video.

- **layers.rb** - Layer a title over a background video using tracks. The title includes a zoom effect and is
    semi-transparent.

- **luma.rb** - Create animated transition effects using a luma matte and the luma matte asset type.

- **merge.rb** -
    Merge data in to a video using merge fields.

- **transform.rb** -
    Apply transformations (rotate, skew and flip) to a video clip.

### Image examples

- **border.rb** - Add a border frame around a background photo.

- **gif.rb** - Create an animated gif that plays once.

### Probe example

- **probe.rb** -
    Fetch metadata for any media asset on the internet such as width, height, duration, etc...
### Polling example

- **status.rb** - Shows the status of a render task and the output video URL. Run this after running one of the render
    examples.

### Asset management examples

- **serve-api/renderId.rb** - Fetch all assets associated with a render ID. Includes video or image and thumbnail and
    poster.

- **serve-api/assetId.rb** - Fetch an individual asset by asset ID.

- **serve-api/destination.rb** - Shows how to exclude a render from being sent to the Shotstack hosting destination.

---

## Installation

Install the required gems including the [Shotstack SDK](https://rubygems.org/gems/shotstack)

```bash
bundle
```

## Set your API key

The demos use the **staging** endpoint by default so use your provided **staging** key:

```bash
export SHOTSTACK_KEY=your_key_here
```

Windows users (Command Prompt):

```bash
set SHOTSTACK_KEY=your_key_here
```

You can [get an API key](http://shotstack.io/?utm_source=github&utm_medium=demos&utm_campaign=ruby_sdk) via the
Shotstack web site.

## Run an example

The examples directory includes a number of examples demonstrating the capabilities of the Shotstack API.

#### Rendering

To run a rendering/editing example run the examples at the root of the examples folder, e.g. to run the images video
example:

```bash
ruby examples/images.rb
```

#### Polling

To check the status of a render, similar to polling run the `status.rb` example with the render ID, e.g.:

```bash
ruby examples/status.rb 8b844085-779c-4c3a-b52f-d79deca2a960
```

#### Asset management

To look up assets hosted by Shotstack run the examples in the [examples/serve-api](./examples/serve-api/) directory.

Find assets by render ID:
```bash
ruby examples/serve-api/renderId.rb 8b844085-779c-4c3a-b52f-d79deca2a960
```

or 

Find an asset by asset ID:
```bash
ruby examples/serve-api/assetId.rb 3f446298-779c-8c8c-f253-900c1627b776
```

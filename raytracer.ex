# module for vectoroperations in R3
defmodule Vector do
  # scalar multiplication a*v
  def smul({x1, x2, x3}, s) do
    {s * x1, s * x2, s * x3}
  end

  # subtract y from x
  def sub({x1, x2, x3}, {y1, y2, y3}) do
    {x1 - y1, x2 - y2, x3 - y3}
  end

  # add two vectors
  def add({x1, x2, x3}, {y1, y2, y3}) do
    {x1 + y1, x2 + y2, x3 + y3}
  end

  # norm/length of vector
  def norm({x1, x2, x3}) do
    :math.sqrt(x1 * x1 + x2 * x2 + x3 * x3)
  end

  # scalar product (dot product) scalar value
  def dot({x1, x2, x3}, {y1, y2, y3}) do
     x1 * y1 + x2 * y2 + x3 * y3
  end

  # normalize vector one, i.e length/norm of vector = 1
  def normalize(x) do
    norm = norm(x)
    smul(x, 1 / norm)
  end
end

# ray has an origin represented by normalized vector and direction vecot
defmodule Ray do
  # default value struct
  defstruct(pos: {0, 0, 0}, dir: {0, 0, 1})
end

# protocol: interface all objects of different types implements.
# protocol achieves polymorhpism, behaviour varies depending on datatype
# as a different object in defined the protocol is instantiated
defprotocol Object do
  # determines if ray intersects with an object
  def intersect(object, ray)

  #defines perpendicular vector to object (for lighting)
  def normal(object, ray, pos)
end

# sphere has pos in origo, with a radius of 2 as default
defmodule Sphere do

  @color {1.0, 0.4, 0.4}
  @brilliance 0
  @transparency 0
  @refraction 1.5

  defstruct(
    radius: 2,
    pos: {0, 0, 0},
    color: @color,
    brilliance: @brilliance,
    transparency: @transparency,
    refraction: @refraction
  )


  defimpl Object do

    def intersect(sphere, ray) do
      Sphere.intersect(sphere, ray)
    end

    #perpendicular normal vector
    def normal(sphere, _, pos) do
      # assuming we always hit it from the outside
      Vector.normalize(Vector.sub(pos, sphere.pos))
    end

  end

  def intersect(%Sphere{pos: spos, radius: radius},  %Ray{pos: rpos, dir: dir}) do
    k = Vector.sub(spos, rpos)
    a = Vector.dot(dir, k)
    a2 = :math.pow(a, 2)
    k2 = :math.pow(Vector.norm(k), 2)
    r2 = :math.pow(radius, 2)
    t2 = a2 - k2 + r2
    closest(t2, a)
  end

  defp closest(t2, a) do
    if t2 < 0 do
      :no
    else
      t = :math.sqrt(t2)
      d1 = a - t
      d2 = a + t

      cond do
        d1 > 0.0 and d2 > 0.0 ->
          {:ok, min(d1, d2)}
        d1 > 0.0 ->
          {:ok, d1}
        d2 > 0.0 ->
          {:ok, d2}
        true ->
          :no
      end
    end
  end
end

# properties of camera: a position in space, direction (unit vector) and size of pic,
# focal length (distance to canvas), resolution (pizles per distance)

# when calculating rays, represent camera by position and vector to upper left corner
# of canvas c. Two vectors represents pixels moving to right (r) and moving down(d)
# normalised vektor to any pixel in canvas: pixel(x,y)= c + xr + yd

# camera struct
defmodule Camera do
  defstruct(
    pos: nil,
    corner: nil,
    right: nil,
    down: nil,
    size: nil
  )

  # default camera values
  # left horisontal, v up, d depth in;
  # corner is top left corner on canvas
  # right is postive x-axis
  # down is negative y-axis directiong
  def normal(size) do
    {width, height} = size
    d = width * 1.2
    h = width / 2
    v = height / 2
    pos = {0, 0, 0}
    corner = {-h, v, d}
    right = {1, 0, 0}
    down = {0, -1, 0}
    %Camera{pos: pos, corner: corner, right: right, down: down, size: size}
  end

  # given a camera, calculate a ray that passes through given coordinate/pixel
  def ray(%Camera{pos: pos, right: right, down: down, corner: corner}, x, y) do
    x_pos = Vector.smul(right, x)
    y_pos = Vector.smul(down, y)
    pixle = Vector.add(corner, Vector.add(x_pos, y_pos))
    dir = Vector.normalize(pixle)
    %Ray{pos: pos, dir: dir}
  end
end

defmodule Tracer do
  # rgb colors
  @black {0, 0, 0}
  @white {1, 1, 1}

  # first for loop will generate list of lists, with color tuples
  def tracer(camera, objects) do
    {w, h} = camera.size

    # let y be between 1 and h,
    # let x be between 1 and w
    # for each point
    for y <- 1..h, do: for(x <- 1..w, do: trace(x, y, camera, objects))
  end

  # return a ray that passes through x and y point (pixel)
  # trace using ray and objects
  def trace(x, y, camera, objects) do
    ray = Camera.ray(camera, x, y)
    trace(ray, objects)
  end

  # given ray and objects
  def trace(ray, objects) do
    # check if ray intersects with object
    case intersect(ray, objects) do
      # if not, infinity
      {:inf, _} ->
        world.background

      # if intersection, white indicates pic on canvas
      {d, obj} ->
        i = Vector.add(ray.pos, Vector.smul(ray.dir, d - @delta))  #delta for margin of error
        normal = Object.normal(obj,ray,i) #i = point of intersection (ray and obj)
        visible = visible(i, world.lights, objects) #all lights in world, give all visible obj
        illumination = Light.combine(i, normal, visible) #return to illumination, give point of intersection + normal + visiblepoint
        Light.illuminate(obj, illumination, world) #what color of point?
    end
  end

  def intersect(ray, objects) do
    # list of all objects, if done with list, return infinity
    List.foldl(
      objects,
      {:inf, nil},
      # operation applied, closets object we've intersected with
      fn object, sofar ->
        {dist, _} = sofar
        # we dont know exact object, all of them implements intersect
        # check if given object intersects with ray
        case Object.intersect(object, ray) do
          # if yes, return this with smallest distance
          {:ok, d} when d < dist -> {d, object}
          _ -> sofar
        end
      end
    )
  end
end

defmodule Snap do
  # first snapshot
  def snap(0) do
    camera = Camera.normal({800, 600})

    # 3 objects, all spheres
    obj1 = %Sphere{radius: 140, pos: {0, 0, 700}}
    obj2 = %Sphere{radius: 50, pos: {200, 0, 600}}
    obj3 = %Sphere{radius: 50, pos: {-80, 0, 400}}

    # give rgb value for each r
    image = Tracer.tracer(camera, [obj1, obj2, obj3])
    # PPM prints out image
    PPM.write("snap0.ppm", image)
  end
end


defmodule World do
  @background {0, 0, 0}
  @ambient{0.3, 0.3, 0.3}

  #give tracer world and camera
  defstruct(objects: [],
            lights: [],
            background: @background,
            ambient: @ambient)
end

defmodule PPM do
  # write(Name, Image) The image is a list of rows, each row a list of
  # tuples {R,G,B} where the values are flots from 0 to 1. The image
  # is written using PMM format P6 and color depth 0-255. This means that
  # each tuple is written as three bytes.

  def write(name, image) do
    height = length(image)
    width = length(List.first(image))
    {:ok, fd} = File.open(name, [:write])
    IO.puts(fd, "P6")
    IO.puts(fd, "#generated by ppm.ex")
    IO.puts(fd, "#{width} #{height}")
    IO.puts(fd, "255")
    rows(image, fd)
    File.close(fd)
  end

  defp rows(rows, fd) do
    Enum.each(rows, fn r ->
      colors = row(r)
      IO.write(fd, colors)
    end)
  end

  defp row(row) do
    List.foldr(row, [], fn {r, g, b}, a ->
      [trunc(r * 255), trunc(g * 255), trunc(b * 255) | a]
    end)
  end
end

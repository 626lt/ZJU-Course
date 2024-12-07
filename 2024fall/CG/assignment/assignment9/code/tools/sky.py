import cv2
import os

def save_face(image, region, output_path):
    """
    Crop and save a face of the skybox.
    """
    face = image[region[1]:region[3], region[0]:region[2]]
    cv2.imwrite(output_path, face)
    print(f"Saved: {output_path}")

def split_skybox(image_path, output_dir):
    """
    Split a 3x4 cross skybox image into 6 faces and save them.
    """
    # Load the image
    image = cv2.imread(image_path)
    if image is None:
        print("Error: Could not load the image.")
        return

    height, width, _ = image.shape

    # Determine the face size (assuming a 3x4 layout)
    face_size = width // 3
    # if height != face_size * 4:
    #     print("Error: Image dimensions do not match a 3x4 cross layout.")
    #     return

    # Define cropping regions for each face
    regions = {
        "top": (face_size, 0, face_size * 2, face_size),                 # Top (+Y)
        "left": (0, face_size, face_size, face_size * 2),               # Left (-X)
        "front": (face_size, face_size, face_size * 2, face_size * 2),  # Front (+Z)
        "right": (face_size * 2, face_size, face_size * 3, face_size * 2),  # Right (+X)
        "bottom": (face_size, face_size * 2, face_size * 2, face_size * 3), # Bottom (-Y)
        "back": (face_size, face_size * 3, face_size * 2, face_size * 4)    # Back (-Z)
    }

    # Ensure the output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Crop and save each face
    for face_name, region in regions.items():
        output_path = os.path.join(output_dir, f"skybox_{face_name}.png")
        save_face(image, region, output_path)

    print("Skybox faces have been successfully saved.")

if __name__ == "__main__":
    # Input image path (replace with your image path)
    input_image_path = "clock_cube.jpg"
    # Output directory for the faces
    output_directory = "../textures/skybox"

    split_skybox(input_image_path, output_directory)
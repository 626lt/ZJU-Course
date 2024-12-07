def convert_quad_to_tri(obj_file, output_file):
    with open(obj_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            if line.startswith('f '):  # 找到面定义
                parts = line.strip().split()
                if len(parts) == 5:  # 四点面（包括 'f' 和 4 个顶点）
                    # 分解为两个三角形
                    tri1 = f"{parts[0]} {parts[1]} {parts[2]} {parts[3]}\n"
                    tri2 = f"{parts[0]} {parts[1]} {parts[3]} {parts[4]}\n"
                    outfile.write(tri1)
                    outfile.write(tri2)
                else:
                    # 保留其他定义（如三角形或其他行）
                    outfile.write(line)
            else:
                outfile.write(line)

# 使用示例
convert_quad_to_tri('car2.obj', '_car2.obj')
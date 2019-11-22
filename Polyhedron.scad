


W1=18; // max middle
W2=9;  // bottom/front
W3=10; // top
H1=16; // top
H2=3; // lower waist
H3=5; // upper waist
L1=4;
L2=6;
L3=15;
L4=20;

Points=[ [-W2/2,0,0], [-W1/2,0,H2], [-W1/2,0,H3], [-W3/2,0,H1], [W3/2,0,H1], [W1/2,0,H3], [W1/2,0,H2], [W2/2,0,0], // 0..7, Rear bulkhead
[-W1/2,L1,H2], [-W1/2,L1,H3], // 8,9, Left side
[W1/2,L1,H2], [W1/2,L1,H3], // 10,11, right side
[-W3/2,L2,H1], [W3/2,L2,H1], // 12,13, top
[W2/2,L3,0], [-W2/2,L3,0], // 14,15, bottom
[W2/2,L4,H2], [W2/2,L4,H3], [-W2/2,L4,H3], [-W2/2,L4,H2] // 16,17,18,19 front
];

// Rear bulkhead, left rear waist, right rear waist, rear top, bottom, left rear upper,
Faces=[ [0,1,2,3,4,5,6,7],[1,8,9,2],[5,11,10,6], [3,12,13,4], [0,7,14,15], [2,9,12,3],
 //front, bottom front
[16,17,18,19], [15,14,16,19]
];

polyhedron(Points,Faces);
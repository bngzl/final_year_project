import numpy as np 
import cv2 
 
cap = cv2.VideoCapture(0)

# HSV Color Sensitivity Ranges 
hul, huh = 145, 164 # Hue 
sal, sah = 58, 182 # Saturation
val, vah = 165, 255 # Value

# Convert ranges into arrays for masking 
HSVLOW=np.array([hul,sal,val])
HSVHIGH=np.array([huh,sah,vah])

while(True): 
	# Read frame and check for retrieval 
	ret, frame = cap.read()
	status = "No targets found"
	if not ret: 
		break 

	# Colour Mask 
	blurred = cv2.GaussianBlur(frame, (5,5),0)
	hsv = cv2.cvtColor(blurred, cv2.COLOR_BGR2HSV)
	mask = cv2.inRange(hsv, HSVLOW, HSVHIGH)

	# Edge Detetction
	edged = cv2.Canny(mask, 50, 150)
	edged = cv2.dilate(edged, None, iterations=1)
	edged = cv2.erode(edged, None, iterations=1)

	# Find and Draw Contours 
	output, contours, hierarchy = cv2.findContours(edged,cv2.RETR_LIST,cv2.CHAIN_APPROX_SIMPLE)
	cv2.drawContours(frame, contours, 3 , (0,255,0), 2)
	# arg 1: Draw contours on frame 
	# arg 2: List of contours found 
	# arg 3: -1: All contours 
	# arg 4: Colour of contours 
	# arg 5: Thickness of contours 

	# Determine size of area inside contour 
	



	# Determine the pixels inside contour 
	# for c in contours: 
	# 	#(x, y), radius = cv2.minEnclosingCircle(c)
	# 	print ('contours detected are: ', c)
	# 	print ('contour area: ', cv2.contourArea(c))

	### Displays 
	cv2.putText(frame, status, (20,30), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,0,255), 2)
	cv2.imshow('contours', frame)
	cv2.imshow('edged', edged)

	if cv2.waitKey(1) & 0xFF == ord('q'): 
		break

# Release capture when done 
cap.release() 
cv2.destroyAllWindows() 
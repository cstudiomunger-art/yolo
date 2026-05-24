-- Allow CMS admins to edit user trips (support corrections from admin UI).

DROP POLICY IF EXISTS "Admin update user_itineraries" ON user_itineraries;
CREATE POLICY "Admin update user_itineraries" ON user_itineraries FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());
/Users/vesperal/Desktop/YOLO/YOLO/Features/Plan/PlanCreateFlowView.swift:462:19 Cannot convert value of type '[()]' to expected argument type '[ItineraryDay]'

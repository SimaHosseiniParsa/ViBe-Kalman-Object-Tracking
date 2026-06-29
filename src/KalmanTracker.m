function [xc, cnv_f] = kalmanTracker(Regions, xc, FrameNumber, cnv_f)

aa = length(Regions);

if aa ~= 0
    cnv_f = 1;
end

if cnv_f == 1

    if FrameNumber > 257 && FrameNumber < 500

        if ~isempty(Regions)
            bb = Regions(1).Centroid;
        else
            bb = [xc(1), xc(3)];
        end

        cc(FrameNumber,1:2) = bb;

        vx = (bb(1) - xc(1)) / 17;
        vy = (bb(2) - xc(3)) / 17;

        sgx = 2;
        sgy = 2;
        dt  = 1;

        R1 = [sgx^2 0; 0 sgy^2];

        H = [1 0 0 0 0;
             0 0 1 0 0];

        F = [1 dt 0 0 0;
             0 1  0 0 0;
             0 0  1 dt 0;
             0 0  0 1 dt;
             0 0  0 0 1];

        P = eye(5);
        I = eye(5);

        Ps = F * P * F';

        K = Ps * H' * inv(H * Ps * H' + R1);

        xc = F*xc + K * ([bb(1)+1.12*vx; bb(2)+1.12*vy] - H*F*xc);

        P = (I-K*H)*Ps*(I-K*H)' + K*R1*K';
    end
end

end
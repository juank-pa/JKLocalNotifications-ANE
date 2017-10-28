package com.juankpro.ane.localnotif;

import com.adobe.fre.FREContext;

import org.junit.Test;
import org.mockito.ArgumentMatchers;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

import static org.junit.Assert.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Created by Juank on 10/23/17.
 */

public class ResourceMapperTest {
    @Mock private FREContext context;
    private ResourceMapper subject;
    private ResourceMapper getSubject() {
        if (subject == null) { subject = new ResourceMapper(); }
        return subject;
    }

    private void setup() {
        MockitoAnnotations.initMocks(this);
        when(context.getResourceId(ArgumentMatchers.anyString())).thenAnswer(new Answer<Integer>() {
            public Integer answer(InvocationOnMock invocation) {
                return 10;
            }
        });
    }

    @Test
    public void resourceMapper_getResourceId_mapsResourceStringToId() {
        setup();
        assertEquals((int)getSubject().getResourceIdFor("any_id", context), 10);
        verify(context).getResourceId("drawable.any_id");
    }
}

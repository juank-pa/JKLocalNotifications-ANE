package com.juankpro.ane.localnotif;

import com.adobe.fre.FREContext;

import org.junit.Test;
import org.mockito.ArgumentMatchers;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

import static org.junit.Assert.*;
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
                String id = (String)invocation.getArguments()[0];
                if (id.equals("drawable.alert_icon")) return 1;
                if (id.equals("drawable.document_icon")) return 2;
                if (id.equals("drawable.error_icon")) return 3;
                if (id.equals("drawable.flag_icon")) return 4;
                if (id.equals("drawable.info_icon")) return 5;
                if (id.equals("drawable.message_icon")) return 6;
                return 0;
            }
        });
    }

    @Test
    public void resourceMapper_mapsAlertToResourceId() {
        setup();
        assertEquals((int)getSubject().getResourceIdFor("alert", context), 1);
    }

    @Test
    public void resourceMapper_mapsDocumentToResourceId() {
        setup();
        assertEquals((int)getSubject().getResourceIdFor("document", context), 2);
    }

    @Test
    public void resourceMapper_mapsErrorToResourceId() {
        setup();
        assertEquals((int)getSubject().getResourceIdFor("error", context), 3);
    }

    @Test
    public void resourceMapper_mapsFlasgToResourceId() {
        setup();
        assertEquals((int)getSubject().getResourceIdFor("flag", context), 4);
    }

    @Test
    public void resourceMapper_mapsInfoToResourceId() {
        setup();
        assertEquals((int)getSubject().getResourceIdFor("info", context), 5);
    }

    @Test
    public void resourceMapper_mapsMessageToResourceId() {
        setup();
        assertEquals((int)getSubject().getResourceIdFor("message", context), 6);
    }
}
